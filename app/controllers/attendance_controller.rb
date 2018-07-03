class AttendanceController < ApplicationController
  def new
    course = Course.find(params[:courseId])
    if(course.is_logging_attendance)
      attendance = Attendance.new(course_id: course.id, student_id: session[:student_id])
      if(attendance.save)
        render json: attendance, serializer: AttendanceSerializer, status: 201
      else
        render json: {errors: attendance.errors.full_messages}, status: 422
      end
    else
      render json: {errors: ['This course is not currently taking attendance']}, status: 403
    end
  end
end
