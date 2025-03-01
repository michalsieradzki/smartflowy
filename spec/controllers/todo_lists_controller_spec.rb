require 'rails_helper'

RSpec.describe TodoListsController, type: :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:project) { create(:project, company: company, project_manager: user) }
  let!(:project_member) { create(:project_member, user: user, project: project) }
  let(:todo_list) { create(:todo_list, project: project) }

  before do
    sign_in user
  end


  context "as project manager" do
    let(:user) { create(:user, :project_manager, company: company) }
    let(:project) { create(:project, company: company, project_manager: user) }

    describe "GET #new" do
      it "returns http success" do
        get :new, params: { project_id: project.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      let(:valid_attributes) { { name: "Nowa lista", position: 1 } }

      it "creates a new todo list" do
        expect {
          post :create, params: { project_id: project.id, todo_list: valid_attributes }
        }.to change(TodoList, :count).by(1)
      end

      it "redirects to project page" do
        post :create, params: { project_id: project.id, todo_list: valid_attributes }
        expect(response).to redirect_to(project_path(project))
      end
    end
  end
end
