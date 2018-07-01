class UsersController < ApplicationController
    def signup
        user = User.new(signup_params)
        if(user.save)
            Teacher.create(user_id: user.id) if user.user_type == 'teacher'
            Student.create(user_id: user.id) if user.user_type == 'student'

            user = User.find(user.id)
            session[:user] = user
            render json: user, serializer: UsersSerializer, status: 201
        else
            render json: {errors: user.errors.full_messages}, status: 422
        end
    end

    def signup_params
        params.require(:user).permit(
            :first_name,
            :last_name,
            :password,
            :email,
            :user_type,
            :password
        )
    end

    def login
        user = User.find_by(email: login_params[:email], user_type: login_params[:user_type])
        if(user.present? && user.authenticate(login_params[:password]))
            session[:user] = user
            render json: user, serializer: UsersSerializer, status: 200
        else
            render json: {errors: ["Invalid email - password combination."]}, status: 422
        end
    end

    def login_params
        params.require(:user).permit(
            :email,
            :password,
            :user_type
        )
    end
end
