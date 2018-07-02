class EnrollmentController < ApplicationController
  def new
    enrollment = Enrollment.new(student_id: session[:student_id], course_id: params[:courseId])
    if(enrollment.save)
      render json: {}, status: 201
    else
      render json: {errors: enrollment.errors.full_messages}, status: 422
    end
  end
end
