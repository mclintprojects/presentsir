class AttendanceController < ApplicationController
  def new
    course = Course.find(params[:courseId])
    if(course.is_logging_attendance)
      attendance = Attendance.new(course_id: course.id, student_id: session[:student_id])
      if(attendance.save)
        render json: attendance, serializer: AttendanceSerializer, status: 201
        Pusher.trigger('present-sir', 'course-attend', {course_id: course.id,
        attendance: AttendanceSerializer.new(attendance)}.as_json)
      else
        render json: {errors: attendance.errors.full_messages}, status: 422
      end
    else
      render json: {errors: ['This course is not currently taking attendance']}, status: 403
    end
  end

  def search
    if(session[:teacher_id].present?)
      date = Date.parse(params[:date])
      render json: Attendance.where('created_at >= ? AND created_at <= ? AND course_id = ?',
        date, date + 1.days, Course.find_by(identifier: params[:identifier]).id),
        each_serializer: AttendanceSerializer, status: 200
    end
  end
end
