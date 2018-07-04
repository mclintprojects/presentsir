require 'rails_helper'
require 'json'

RSpec.describe CourseRepController, type: :controller do
    describe "POST #new" do
        let(:user) {create(:user)}
        let(:teacher) {create(:teacher)}
        it "will assign as a course rep" do
            student = Student.create(user_id: user.id)
            session[:teacher_id] = teacher.id

            course = Course.create(teacher_id: teacher.id, name: 'Test', 'identifier': 'Test')

            before_count = CourseRep.all.count
            post :new, {params: {email: user.email, courseId: course.id}}
            expect(response).to have_http_status(201)
            expect(CourseRep.all.count).to eq(before_count + 1)
        end

        it "will not assign a new course rep if already assigned" do
            student = Student.create(user_id: user.id)
            session[:teacher_id] = teacher.id

            course = Course.create(teacher_id: teacher.id, name: 'Test', 'identifier': 'Test')

            post :new, {params: {email: user.email, courseId: course.id}}
            post :new, {params: {email: user.email, courseId: course.id}}
            expect(response).to have_http_status(422)
        end

        it "will not create a new course rep for a course it isn't a teacher of" do
            user = create(:user)
            student = Student.create(user_id: user.id)
            
            teacher1 = create(:teacher)
            teacher2 = create(:teacher)
            session[:teacher_id] = teacher1.id

            course = Course.create(teacher_id: teacher2.id, name: 'Test', 'identifier': 'Test')

            post :new, {params: {email: user.email, courseId: course.id}}
            expect(response).to have_http_status(403)
        end
    end

    describe "DELETE #delete" do
        it "will delete course rep if it is teacher who assigned course rep" do
            user = create(:user)
            student = Student.create(user_id: user.id)
            
            teacher = create(:teacher)
            session[:teacher_id] = teacher.id

            course = Course.create(teacher_id: teacher.id, name: 'Test', 'identifier': 'Test')
            course_rep = CourseRep.create(student_id: student.id, course_id: course.id)

            before_count = CourseRep.all.count
            delete :delete, params: {id: course_rep.id}
            expect(response).to have_http_status(200)
            expect(CourseRep.all.count).to eq(before_count - 1)
        end

        it "will not delete course rep if it is not teacher who assigned course rep" do
            user = create(:user)
            student = Student.create(user_id: user.id)
            
            teacher = create(:teacher)
            session[:teacher_id] = 0

            course = Course.create(teacher_id: teacher.id, name: 'Test', 'identifier': 'Test')
            course_rep = CourseRep.create(student_id: student.id, course_id: course.id)

            delete :delete, params: {id: course_rep.id}
            expect(response).to have_http_status(403)
        end
    end

    describe "GET #whoami" do
        it "will let me know if i am a course rep" do
            student = create(:student)
            course = create(:course)
            course_rep = CourseRep.create(student_id: student.id, course_id: course.id)

            session[:student_id] = student.id

            get :whoami, params: {id: course_rep.id}
            expect(JSON.parse(response.body)["is_course_rep"]).to eq(true)
        end
    end

    describe "GET #courses" do
        it "will get the courses assigned to the course rep" do
            student = create(:student)
            course = create(:course)
            course_rep = CourseRep.create(student_id: student.id, course_id: course.id)

            session[:student_id] = student.id

            get :courses            
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)[0]["name"]).to eq(course.name)
        end
    end
end
