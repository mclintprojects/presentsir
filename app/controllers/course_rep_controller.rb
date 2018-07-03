class CourseRepController < ApplicationController
    def new
        if(session[:teacher_id].present?)
            student = Student.find_by(user_id: User.find_by(email: params[email]))
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
end
