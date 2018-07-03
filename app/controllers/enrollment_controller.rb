class EnrollmentController < ApplicationController
  def all_student
    render json: Enrollment.where('student_id = ?', session[:student_id]), each_serializer: EnrollmentSerializer
  end
  
  def new
    enrollment = Enrollment.new(student_id: session[:student_id], course_id: params[:courseId])
    if(enrollment.save)
      render json: {}, status: 201
    else
      render json: {errors: enrollment.errors.full_messages}, status: 422
    end
  end

  def is_logging_attendance
    enrolled_courses_ids = Enrollment.where('student_id = ?', session[:student_id]).pluck(:course_id).to_a
    logging_ids = Course.where('is_logging_attendance = ? AND id IN (?)', true, enrolled_courses_ids).select(:id).to_a

    logging_enrollments = Enrollment.where('course_id IN (?)', logging_ids)
    render json: logging_enrollments
  end

  def delete
    render json: {}
  end
end
