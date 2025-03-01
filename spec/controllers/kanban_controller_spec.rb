require 'rails_helper'

RSpec.describe KanbanController, type: :controller do
  let(:company) { create(:company) }

  # Użytkownicy o różnych rolach
  let(:superadmin) { create(:user, :superadmin, company: company) }
  let(:company_admin) { create(:user, :company_admin, company: company) }
  let(:project_manager) { create(:user, :project_manager, company: company) }
  let(:regular_user) { create(:user, company: company) }

  # Projekty
  let(:pm_project) do
    project = build(:project, company: company)
    project.project_manager = project_manager
    project.save!
    project
  end

  let(:other_project) do
    # Tworzymy innego kierownika projektu dla other_project
    other_pm = create(:user, :project_manager, company: company)
    project = build(:project, company: company)
    project.project_manager = other_pm
    project.save!
    project
  end

  let!(:pm_project_member) { create(:project_member, project: pm_project, user: regular_user) }

  # Listy zadań
  let(:todo_list) { create(:todo_list, project: pm_project) }
  let(:other_todo_list) { create(:todo_list, project: other_project) }

  # Zadania
  let!(:assigned_task) { create(:task, todo_list: todo_list, assignee: regular_user, status: :pending) }
  let!(:unassigned_task) { create(:task, todo_list: todo_list, status: :in_progress) }
  let!(:other_task) { create(:task, todo_list: other_todo_list, status: :completed) }

  describe "GET #index" do
    context "jako zwykły użytkownik" do
      before do
        sign_in regular_user
        get :index
      end

      it "zwraca status 200" do
        expect(response).to have_http_status(:success)
      end

      it "przypisuje projekty użytkownika do @projects" do
        expect(assigns(:projects)).to include(pm_project)
      end

      it "przypisuje zadania z projektów użytkownika i przypisane zadania do @tasks" do
        expect(assigns(:tasks)).to include(assigned_task, unassigned_task)
        expect(assigns(:tasks)).not_to include(other_task)
      end
    end

    context "jako kierownik projektu" do
      before do
        sign_in project_manager
        get :index
      end

      it "przypisuje zarządzane projekty do @projects" do
        get :index
        expect(assigns(:projects)).to include(pm_project)
      end

      it "przypisuje zadania z zarządzanych projektów do @tasks" do
        get :index
        expect(assigns(:tasks)).to include(assigned_task, unassigned_task)
      end
    end

    context "jako administrator firmy" do
      before do
        sign_in company_admin
        get :index
      end

      it "przypisuje wszystkie zadania firmy do @tasks" do
        expect(assigns(:tasks)).to include(assigned_task, unassigned_task, other_task)
      end
    end
  end

  describe "POST #update_status" do
    context "jako zwykły użytkownik" do
      before do
        sign_in regular_user
      end

      it "pozwala zmienić status przypisanego zadania" do
        post :update_status, params: { task_id: assigned_task.id, status: "completed" }, format: :json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["success"]).to eq(true)
        expect(assigned_task.reload.status).to eq("completed")
      end

      it "nie pozwala zmienić statusu nieprzypisanego zadania" do
        post :update_status, params: { task_id: unassigned_task.id, status: "completed" }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "jako kierownik projektu" do
      before do
        sign_in project_manager
      end

      it "pozwala zmienić status zadania w zarządzanym projekcie" do
        post :update_status, params: { task_id: assigned_task.id, status: "completed" }, format: :json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["success"]).to eq(true)
        expect(assigned_task.reload.status).to eq("completed")
      end

      it "nie pozwala zmienić statusu zadania w niezarządzanym projekcie" do
        post :update_status, params: { task_id: other_task.id, status: "completed" }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "jako administrator firmy" do
      before do
        sign_in company_admin
      end

      it "pozwala zmienić status dowolnego zadania w firmie" do
        post :update_status, params: { task_id: other_task.id, status: "in_progress" }, format: :json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["success"]).to eq(true)
        expect(other_task.reload.status).to eq("in_progress")
      end
    end
  end
end
