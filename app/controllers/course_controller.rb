class CourseController < ApplicationController
  def all
    render json: Course.where(teacher_id: session[:teacher_id]), each_serializer: CourseSerializer, status: 200
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
    render json: {}, status: 200
  end
end
