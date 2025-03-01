require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:project) { create(:project, company: company) }
  let!(:project_member) { create(:project_member, user: user, project: project) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns @projects" do
      get :index
      expect(assigns(:projects)).to include(project)
    end
  end

  describe "GET #show" do
    it "returns http success for member" do
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end

    it "redirects for non-member" do
      # Utwórz projekt, do którego użytkownik nie ma dostępu
      other_project = create(:project, company: company)

      # Upewnij się, że nie ma powiązania między użytkownikiem a projektem
      expect(user.project_ids).not_to include(other_project.id)

      # Wywołaj akcję
      get :show, params: { id: other_project.id }

      # Oczekuj przekierowania do listy projektów
      expect(response).to redirect_to(projects_path)
    end
  end
end
