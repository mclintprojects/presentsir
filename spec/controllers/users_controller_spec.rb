require 'rails_helper'
require 'json'

RSpec.describe UsersController, type: :controller do
    describe '#POST users/signup' do
        it 'should create a new user' do
            before_count = User.all.count

            user_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: Forgery('basic').password,
                user_type: 'teacher'
            };

            post :signup, params: {user: user_params}
            expect(User.all.count).to eq(before_count + 1)
            expect(User.last.first_name).to eq(user_params[:first_name])
            expect(response).to have_http_status(201)
        end
    end

    describe '#POST users/login' do
        it 'should create a new user' do
            user_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: Forgery('basic').password,
                user_type: 'teacher'
            };

            User.create(user_params);

            post :login, params: {user: user_params}
            expect(JSON.parse(response.body)['first_name']).to eq(user_params[:first_name])
            expect(response).to have_http_status(200)
        end

        it 'should login user type to appropriate dashboard' do
            teacher_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: Forgery('basic').password,
                user_type: 'teacher'
            };

            User.create(teacher_params);

            teacher_params[:user_type] = "student"
            post :login, params: {user: teacher_params}
            expect(response).to have_http_status(422)
        end
    end
end
