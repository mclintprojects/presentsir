class EnrollmentController < ApplicationController
  def all_student #all enrollments a user made
    render json: Enrollment.where('student_id = ?', session[:student_id]), each_serializer: EnrollmentSerializer
  end

  def all_course #all enrollments a course has
    render json: Enrollment.where('course_id = ?', params[:courseId]), each_serializer: EnrollmentSerializer
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
    attended_ids = Attendance.where('student_id = ? AND created_at >= ?',
       session[:student_id], Time.zone.now.beginning_of_day).pluck(:course_id).to_a

    logging_ids = Course.where('is_logging_attendance = ? AND (id IN (?) AND id NOT IN (?))',
     true, enrolled_courses_ids, attended_ids+[0]).select(:id).to_a
    
    logging_enrollments = Enrollment.where('course_id IN (?)', logging_ids)
    render json: logging_enrollments
  end

  def delete
    Enrollment.find(params[:id]).destroy
    render json: {}, status: 200
  end
end
