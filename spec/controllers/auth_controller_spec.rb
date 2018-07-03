require 'rails_helper'

RSpec.describe AuthController, type: :controller do
    describe "GET #session" do
        it "will return course that matches id" do
            user = User.create(first_name: 'Test', last_name: 'Test', email: 'test@gmail.com', password: 'password', user_type: 'teacher')
            teacher = Teacher.create(user_id: user.id)
            @controller = UsersController.new
            get :login, params: {user: {email: user.email, password: user.password, user_type: 'teacher'}}

            @controller = AuthController.new
            get :get_session
            expect(JSON.parse(response.body)["user"]["email"]).to eq('test@gmail.com')
            expect(response).to have_http_status(200)
        end
    end

    describe "GET #logout" do
        it "will logout and clear session" do
            get :logout
            expect(session[:user].present?).to eq(false)
            expect(response).to have_http_status(200)
        end
    end
end
