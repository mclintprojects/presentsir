class CourseController < ApplicationController
  def search
    render json: Course.find(params[:id]), serializer: CourseSerializer
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
