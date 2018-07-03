require 'rails_helper'
require 'json'

RSpec.describe CourseController, type: :controller do

  describe "GET #search" do
    let(:course){create(:course)}
    it "will return course that matches id" do
      get :search, params: {id: course.id}
      expect(JSON.parse(response.body)["id"]).to eq(course.id)
      expect(response).to have_http_status(200)
    end

    it "will return course that matches identifier" do
      course = create(:course)

      get :search, params: {identifier: course.identifier}
      expect(JSON.parse(response.body)["identifier"]).to eq(course.identifier)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #new" do
    it "returns http success" do
      user = create(:user)
      teacher = Teacher.create(user_id: user.id)
      session[:user] = user
      session[:teacher_id] = teacher.id

      before_count = Course.all.count

      post :new, params: {course: {name: 'Test'}}
      expect(JSON.parse(response.body)["identifier"]).to eq("CRS-#{user.last_name.first(2).upcase}#{user.first_name.last(2).upcase}-1")
      expect(Course.all.count).to eq(before_count + 1)
      expect(response).to have_http_status(201)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      post :update
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #all" do
    it "returns all teacher's courses" do
      teacher = create(:teacher)
      session[:teacher_id] = teacher.id
      course = Course.create(teacher_id: teacher.id, name: 'Test', identifier: 'test')

      get :all
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end

  describe "DELETE #delete" do
    it "will delete course" do
      course = create(:course)

      before_count = Course.all.count
      session[:teacher_id] = course.teacher_id
      post :delete, params: {id: course.id}
      expect(response).to have_http_status(200)
      expect(Course.all.count).to eq(before_count - 1)
    end

    it "will not delete another teacher's course" do
      course = create(:course)

      before_count = Course.all.count
      session[:teacher_id] = -1
      post :delete, params: {id: course.id}
      expect(response).to have_http_status(403)
      expect(Course.all.count).to eq(before_count)
    end
  end

end
