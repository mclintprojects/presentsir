class AuthController < ApplicationController
    def get_session
        user = session[:user]
        
        if(user.present?)
            render json: {user: UsersSerializer.new(User.find(user["id"]))}
        else
            render json: {user: nil}
        end
    end

    def logout
        session.delete(:user)
        render json: {user: session[:user]}, status: 200
    end
end
