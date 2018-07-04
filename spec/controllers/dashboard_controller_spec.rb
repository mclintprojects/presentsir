require 'rails_helper'
require 'json'

RSpec.describe DashboardController, type: :controller do

  describe "GET #stats" do
    it "returns stats for logged in teacher" do
      course = create(:course)
      session[:teacher_id] = course.teacher.id

      student = create(:student)
      course_rep = CourseRep.create(student_id: student.id, course_id: course.id)

      enrollment = Enrollment.create(student_id: student.id, course_id: course.id)
      attendance = Attendance.create(course_id: course.id, student_id: student.id, created_at: Time.zone.now.beginning_of_day)

      get :stats
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["stats"]["course_reps"]).to eq(1)
      expect(JSON.parse(response.body)["stats"]["total_attendance"]).to eq(1)
      expect(JSON.parse(response.body)["stats"]["attendance_today"]).to eq(1)
      expect(JSON.parse(response.body)["stats"]["total_enrolled"]).to eq(1)
      expect(JSON.parse(response.body)["courses"][0]["id"]).to eq(course.id)
    end
  end

end
