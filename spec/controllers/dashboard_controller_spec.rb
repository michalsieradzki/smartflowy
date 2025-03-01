require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:project) { create(:project, company: company) }
  let(:project_member) { create(:project_member, user: user, project: project) }

  before do
    sign_in user
    project_member # zapewnia, że user jest członkiem projektu
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns @my_projects" do
      get :index
      expect(assigns(:my_projects)).to include(project)
    end
    context "when user is project manager" do
      let(:project_manager) { create(:user, :project_manager, company: company) }

      it "assigns @managed_projects" do
        # Ważne: Najpierw sign_in, potem tworzenie projektu, żeby powiązanie było widoczne
        sign_in project_manager

        # Bezpośrednio przypisujemy project managera do projektu
        project = create(:project, company: company, project_manager: project_manager, without_manager: true)

        # Wywołaj akcję po utworzeniu projektu
        get :index

        # Debugowanie
        puts "Project Manager ID: #{project_manager.id}"
        puts "Project.project_manager_id: #{project.project_manager_id}"
        puts "Managed projects IDs: #{assigns(:managed_projects).pluck(:id)}"

        expect(assigns(:managed_projects)).to include(project)
      end
    end
  end
end
