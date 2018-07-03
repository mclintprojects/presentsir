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
      Pusher.trigger('present-sir', 'course-enroll', {course_id: enrollment.course_id,
      enrollment: EnrollmentSerializer.new(enrollment)}.as_json)
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

    logging_enrollments = Enrollment.where('course_id IN (?) AND student_id = ?', logging_ids, session[:student_id])
    render json: logging_enrollments
  end

  def delete
    enrollment = Enrollment.find(params[:id])
    data = {course_id: enrollment.course_id, enrollment_id: enrollment.id}

    enrollment.destroy
    render json: {}, status: 200
    Pusher.trigger('present-sir', 'course-unenroll', data.as_json)
  end
end
