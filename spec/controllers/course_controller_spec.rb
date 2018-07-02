require 'rails_helper'
require 'json'

RSpec.describe CourseController, type: :controller do

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
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      post :update
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #delete" do
    it "returns http success" do
      post :delete
      expect(response).to have_http_status(:success)
    end
  end

end
