require 'rails_helper'

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

    it "will not allow student to mark attendance twice in a day" do
      course = create(:logging_course)
      student = create(:student)
      session[:student_id] = student.id

      get :new, params: {courseId: course.id}
      get :new, params: {courseId: course.id}
      expect(response).to have_http_status(422)
    end
  end

end
