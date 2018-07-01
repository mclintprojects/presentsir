class UsersController < ApplicationController
    def signup
        user = User.new(signup_params)
        if(user.save)
            session[:user_id] = user.id
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
end
