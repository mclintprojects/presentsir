class AuthController < ApplicationController
    def get_session
        user = session[:user]
        if user.present?
            binding.pry
            user.delete("password")
            user.delete("password_digest")
        end
        render json: {user: user}
    end

    def logout
        session.delete(:user)
        render json: {user: session[:user]}, status: 200
    end
end
