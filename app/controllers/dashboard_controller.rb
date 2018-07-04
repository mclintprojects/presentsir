class DashboardController < ApplicationController
  def stats
    total_enrolled = Enrollment.where('course_id IN (?)', 
    Course.where('teacher_id = ?', session[:teacher_id]).select(:id).to_a).count

    total_attendance = Attendance.where('course_id IN (?)', 
    Course.where('teacher_id = ?', session[:teacher_id]).select(:id).to_a).count

    attendance_today = Attendance.where('course_id IN (?) AND created_at >= ?', 
    Course.where('teacher_id = ?', session[:teacher_id]).select(:id).to_a, Time.zone.now.beginning_of_day).count
    
    course_reps = CourseRep.where('course_id IN (?)', 
    Course.where('teacher_id = ?', session[:teacher_id]).select(:id).to_a).count

    data = {
      total_enrolled: total_enrolled,
      total_attendance: total_attendance,
      attendance_today: attendance_today,
      course_reps: course_reps
    }

    courses = Course.where('teacher_id = ?', session[:teacher_id])

    render json: { stats: data, courses: ActiveModelSerializers::SerializableResource.new(courses) }, status: 200
  end
end
