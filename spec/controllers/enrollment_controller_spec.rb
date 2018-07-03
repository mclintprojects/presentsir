require 'rails_helper'
require 'json'

RSpec.describe EnrollmentController, type: :controller do

  describe "POST #new" do
    it "will save a new enrollment" do
      course = create(:course)
      student = create(:student)

      session[:student_id] = student.id

      before_count = Enrollment.all.count
      post :new, params: {courseId: course.id}
      expect(response).to have_http_status(201)
      expect(Enrollment.all.count).to eq(before_count + 1)
    end

    it "will not save an existing enrollment" do
      course = create(:course)
      student = create(:student)

      session[:student_id] = student.id

      post :new, params: {courseId: course.id}
      post :new, params: {courseId: course.id}
      expect(response).to have_http_status(422)
    end
  end

  describe "GET #all_student" do
    it "will get all enrollments by student" do
      course = create(:course)
      student = create(:student)
      enrollment = Enrollment.create(course_id: course.id, student_id: student.id)

      session[:student_id] = student.id

      get :all_student
      expect(response).to have_http_status(200)
      expect(Enrollment.all.count).to eq(1)
    end
  end

  describe "GET #is_logging_attendance" do
    it "will get all enrollments logging attendance" do
      course1 = create(:logging_course)
      course2 = create(:course)

      student = create(:student)
      session[:student_id] = student.id

      enrollment1 = Enrollment.create(course_id: course1.id, student_id: student.id)
      enrollment2 = Enrollment.create(course_id: course2.id, student_id: student.id)

      get :is_logging_attendance
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

end
