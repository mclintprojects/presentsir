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

  def search
    date = Date.parse(params[:date])
    if(params[:is_course_rep].present?)
      render json: Attendance.where('created_at >= ? AND created_at <= ? AND course_id = ?',
        date, date + 1.days, Course.find_by(identifier: params[:identifier]).id),
        each_serializer: AttendanceSerializer, status: 200
    else
        render json: Attendance.where('created_at >= ? AND created_at <= ? AND course_id = ? AND approved = ?',
        date, date + 1.days, Course.find_by(identifier: params[:identifier]).id, true),
        each_serializer: AttendanceSerializer, status: 200
    end
  end

  def approve
    if(session[:teacher_id].present? || session[:student_id])
      attendance = Attendance.find(params[:id])
      if(attendance.present?)
        attendance.update_attributes(approved: true)
        render json: attendance, serializer: AttendanceSerializer, status: 200
        Pusher.trigger(pusher_channel_name, 'course-attend', {course_id: attendance.course_id,
        attendance: ActiveModelSerializers::SerializableResource.new(attendance).as_json})
      else
        render json: {}, status: 404
      end
    end
  end
end
