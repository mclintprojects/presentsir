require 'rails_helper'
require 'json'

RSpec.describe AttendanceController, type: :controller do

  describe "GET #new" do
    it "will mark student as present in enrolled course" do
      course = create(:logging_course)
      student = create(:student)
      session[:student_id] = student.id

      before_count = Attendance.all.count
      get :new, params: {courseId: course.id}
      expect(response).to have_http_status(201)
      expect(Attendance.last.student_id).to eq(student.id)
      expect(Attendance.last.course_id).to eq(course.id)
      expect(Attendance.all.count).to eq(before_count + 1)
    end

    it "will not allow student to mark attendance if course is not taking attendance" do
      course = create(:course)
      student = create(:student)
      session[:student_id] = student.id

      get :new, params: {courseId: course.id}
      expect(response).to have_http_status(403)
    end
  end

  describe "GET #search" do
    it "will get all attendance on a particular day" do
      course = create(:logging_course)
      teacher = create(:teacher)
      student = create(:student)
      attendance = Attendance.create(course_id: course.id, student_id: student.id, created_at: Time.zone.now.beginning_of_day, approved: true)
      session[:teacher_id] = teacher.id

      get :search, params: {date: attendance.created_at, identifier: course.identifier}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)[0]["id"]).to eq(attendance.id)
    end
  end

  describe "GET #search" do
    it "will approve attendance" do
      attendance = create(:attendance)
      session[:teacher_id] = attendance.course.teacher.id

      get :approve, params: {id: attendance.id}
      expect(response).to have_http_status(200)
      expect(Attendance.find(attendance.id).approved).to eq(true)
    end
  end

end
