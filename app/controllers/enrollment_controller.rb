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
    not_logging_ids = Course.where('is_logging_attendance = ?', true).select(:id)
    not_logging_enrollments = Enrollment.where('student_id = ? AND course_id IN (?)', session[:student_id], not_logging_ids.to_a)
    render json: not_logging_enrollments
  end

  def delete
    render json: {}
  end
end
