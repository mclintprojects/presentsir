require 'rails_helper'

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
end
