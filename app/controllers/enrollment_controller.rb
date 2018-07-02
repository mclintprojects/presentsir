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
end
