class CourseController < ApplicationController
  def search
    course = nil
    if(params[:id].present?)
      course = Course.find(params[:id])
    elsif (params[:identifier].present?)
      course = Course.find_by(identifier: params[:identifier])
    end

    if(course.present?)
      render json: course, serializer: CourseSerializer
    else
      render json: {errors: ['Could not find a course matching those parameters']}, status: 422
    end
  end
  
  def all
    data = Course.where(teacher_id: session[:teacher_id])
    total_count = data.count
    data = data.page(params[:pageNumber]).per(30)
    
    pagination = {
      current_page: data.current_page,
      prev_page: data.prev_page,
      next_page: data.next_page,
      total_count: total_count,
     }

    render json: data, each_serializer: CourseSerializer, status: 200, meta: pagination, adapter: :json
  end

  def mark_attendance
    course = Course.find(params[:id])
    course_rep = CourseRep.find_by(student_id: session[:student_id], course_id: course.id)

    if((session[:teacher_id].present? && course.teacher_id == session[:teacher_id]) ||
      (course_rep.present? && course_rep.course_id == course.id))

      course.update_attributes(is_logging_attendance: params[:state])
      render json: {}, status: 200

      Pusher.trigger('present-sir', 'mark_attendance', {state: course.is_logging_attendance, id: course.id}.as_json)
    else
      render json: {}, status: 403
    end
  end

  def new
    teacher_id = session[:teacher_id]
    course = Course.new(course_params)
    course.teacher_id = teacher_id
    course.identifier = "CRS-#{session[:user]["last_name"].first(2).upcase}#{session[:user]["first_name"].last(2).upcase}-#{Course.where(teacher_id: teacher_id).count + 1}"

    if(course.save)
      render json: course, serializer: CourseSerializer, status: 201
    else
      render json: {errors: course.errors.full_messages}, status: 422
    end
  end

  def course_params
    params.require(:course).permit(
      :course_code,
      :name
    )
  end

  def update
    render json: {}, status: 200
  end

  def delete
    course = Course.find(params[:id])
    if(session[:teacher_id] == course.teacher_id)
      course.destroy
      render json: {}, status: 200
    else
      render json: {errors: ['You cannot delete this course.']}, status: 403
    end
  end
end
