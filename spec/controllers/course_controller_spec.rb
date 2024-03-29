require 'rails_helper'
require 'json'

RSpec.describe CourseController, type: :controller do

  describe "GET #search" do
    let(:course){create(:course)}
    it "will return course that matches id" do
      get :search, params: {id: course.id}
      expect(JSON.parse(response.body)["id"]).to eq(course.id)
      expect(response).to have_http_status(200)
    end

    it "will return course that matches identifier" do
      course = create(:course)

      get :search, params: {identifier: course.identifier}
      expect(JSON.parse(response.body)["identifier"]).to eq(course.identifier)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #new" do
    it "will create a new course" do
      user = create(:user)
      teacher = Teacher.create(user_id: user.id)
      session[:user] = user
      session[:teacher_id] = teacher.id

      before_count = Course.all.count

      post :new, params: {course: {name: 'Test'}}
      expect(JSON.parse(response.body)["identifier"]).to eq("CRS-#{user.last_name.first(2).upcase}#{user.first_name.last(2).upcase}-1")
      expect(Course.all.count).to eq(before_count + 1)
      expect(response).to have_http_status(201)
    end

    it "will not create a new course if existing course code + name exists" do
      user = create(:user)
      teacher = Teacher.create(user_id: user.id)
      session[:user] = user
      session[:teacher_id] = teacher.id

      post :new, params: {course: {name: 'Test', course_code: 'TEST 302'}}
      post :new, params: {course: {name: 'Test', course_code: 'TEST 302'}}
      expect(response).to have_http_status(422)
    end
  end

  describe "POST #mark_attendance" do
    let(:course){create(:course)}
    let(:student){create(:student)}

    it "will initiate attendance logging session as course teacher" do
      session[:teacher_id] = course.teacher.id

      post :mark_attendance, params: {id: course.id, state: true}
      expect(response).to have_http_status(200)
      expect(Course.find(course.id).is_logging_attendance).to eq(true)
    end

    it "will initiate attendance logging session as assigned course rep" do
      course_rep = CourseRep.create(student_id: student.id, course_id: course.id)
      session[:student_id] = student.id

      post :mark_attendance, params: {id: course.id, state: true}
      expect(response).to have_http_status(200)
      expect(Course.find(course.id).is_logging_attendance).to eq(true)
    end

    it "will reject attendance logging session if not course teacher or an assigned class rep" do
      course_rep = CourseRep.create(student_id: student.id, course_id: course.id)
      session[:student_id] = 0

      post :mark_attendance, params: {id: course.id, state: true}
      expect(response).to have_http_status(403)
    end

    it "will reject attendance logging session if not course teacher" do
      session[:teacher_id] = 0

      post :mark_attendance, params: {id: course.id, state: true}
      expect(response).to have_http_status(403)
    end
  end

  describe "GET #all" do
    it "returns all teacher's courses" do
      teacher = create(:teacher)
      session[:teacher_id] = teacher.id
      course = Course.create(teacher_id: teacher.id, name: 'Test', identifier: 'test')

      get :all
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end

  describe "DELETE #delete" do
    it "will delete course" do
      course = create(:course)

      before_count = Course.all.count
      session[:teacher_id] = course.teacher_id
      post :delete, params: {id: course.id}
      expect(response).to have_http_status(200)
      expect(Course.all.count).to eq(before_count - 1)
    end

    it "will not delete another teacher's course" do
      course = create(:course)

      before_count = Course.all.count
      session[:teacher_id] = -1
      post :delete, params: {id: course.id}
      expect(response).to have_http_status(403)
      expect(Course.all.count).to eq(before_count)
    end
  end

end
