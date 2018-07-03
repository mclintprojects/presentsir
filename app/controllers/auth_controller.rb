class AuthController < ApplicationController
    def get_session
        user = session[:user]
        render json: {user: UsersSerializer.new(User.find(user["id"]))}
    end

    def logout
        session.delete(:user)
        render json: {user: session[:user]}, status: 200
    end
end
