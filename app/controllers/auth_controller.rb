class AuthController < ApplicationController
    def get_session
        user = session[:user]
        user.delete("password") if user.present?
        render json: {user: user}
    end
end
