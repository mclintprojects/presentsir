require 'rails_helper'

RSpec.describe EnrollmentController, type: :controller do

  describe "POST #new" do
    it "will save a new enrollment" do
      course = create(:course)
      student = Student.create(user_id: User.last.id)

      session[:student_id] = student.id

      before_count = Enrollment.all.count
      post :new, params: {courseId: course.id}
      expect(response).to have_http_status(201)
      expect(Enrollment.all.count).to eq(before_count + 1)
    end
  end

end
