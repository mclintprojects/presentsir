class CourseController < ApplicationController
  def all
    render json: Course.all, each_serializer: CourseSerializer, status: 200
  end

  def new
    teacher = Teacher.find_by(user_id: session[:user]["id"])
    course = Course.new(course_params)
    course.teacher_id = teacher.id
    course.identifier = "CRS-#{session[:user]["last_name"].upcase}-#{Course.where(teacher_id: teacher.id).count + 1}"

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
