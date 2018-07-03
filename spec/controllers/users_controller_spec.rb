require 'rails_helper'
require 'json'

RSpec.describe UsersController, type: :controller do
    describe '#POST users/signup' do
        it 'should create a new teacher' do
            before_count = User.all.count

            user_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: 'password',
                user_type: 'teacher'
            };

            post :signup, params: {user: user_params}
            expect(User.all.count).to eq(before_count + 1)
            expect(session[:teacher_id]).to eq(Teacher.last.id)
            expect(Teacher.all.count).to eq(1)
            expect(User.last.first_name).to eq(user_params[:first_name])
            expect(response).to have_http_status(201)
        end

        it 'should create a new student' do
            before_count = User.all.count

            user_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: 'password',
                user_type: 'student'
            };

            post :signup, params: {user: user_params}
            expect(User.all.count).to eq(before_count + 1)
            expect(session[:student_id]).to eq(Student.last.id)
            expect(Student.all.count).to eq(1)
            expect(User.last.first_name).to eq(user_params[:first_name])
            expect(response).to have_http_status(201)
        end
    end

    describe '#POST users/login' do
        it 'should login teacher' do
            user_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: 'password',
                user_type: 'teacher'
            };

            user = User.create(user_params);
            teacher = Teacher.create(user_id: user.id)

            post :login, params: {user: user_params}
            expect(JSON.parse(response.body)['first_name']).to eq(user_params[:first_name])
            expect(session[:teacher_id]).to eq(teacher.id)
            expect(response).to have_http_status(200)
        end

        it 'should login user' do
            user_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: 'password',
                user_type: 'student'
            };

            user = User.create(user_params);
            student = Student.create(user_id: user.id)

            post :login, params: {user: user_params}
            expect(JSON.parse(response.body)['first_name']).to eq(user_params[:first_name])
            expect(session[:student_id]).to eq(student.id)
            expect(response).to have_http_status(200)
        end

        it 'should login user type to appropriate dashboard' do
            teacher_params = {
                first_name: Forgery('name').first_name,
                last_name: Forgery('name').last_name,
                email: Forgery('internet').email_address,
                password: 'password',
                user_type: 'teacher'
            };

            User.create(teacher_params);

            teacher_params[:user_type] = "student"
            post :login, params: {user: teacher_params}
            expect(response).to have_http_status(422)
        end
    end
end
