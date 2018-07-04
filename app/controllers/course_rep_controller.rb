class CourseRepController < ApplicationController
    def new
        if(session[:teacher_id].present?)
            student = Student.find_by(user_id: User.find_by(email: params[:email]))
            course_rep = CourseRep.new(student_id: student.id, course_id: params[:courseId])

            if(course_rep.save)
                render json: course_rep, serializer: CourseRepSerializer, status: 201
            else
                render json: {errors: course_rep.errors.full_messages}, status: 422
            end
        else
            render json: {}, status: 403
        end
    end

    def delete
        course_rep = CourseRep.find(params[:id])
        if(session[:teacher_id] == course_rep.course.teacher_id)
            course_rep.destroy
            render json: {}, status: 200
        else
            render json: {}, status: 403
        end
    end

    def whoami
        is_course_rep = CourseRep.find_by(student_id: session[:student_id]).present?
        render json: {is_course_rep: is_course_rep}, status: 200
    end

    def courses
        courses = Course.where('id in (?)', CourseRep.where(student_id: session[:student_id]).pluck(:course_id).to_a)
        render json: courses, each_serializer: CourseSerializer::SimpleCourseSerializer, status: 200
    end
end
