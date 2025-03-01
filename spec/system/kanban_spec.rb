require 'rails_helper'

RSpec.describe "Kanban Board", type: :system do
  include Devise::Test::IntegrationHelpers

  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:project_manager) { create(:user, :project_manager, company: company) }

  let(:project) do
    project = build(:project, company: company)
    project.project_manager = project_manager
    project.save!
    project
  end

  before do
    # Dodaj użytkownika do projektu
    create(:project_member, project: project, user: user)

    # Utwórz listę zadań i zadania
    todo_list = create(:todo_list, project: project)
    create(:task, todo_list: todo_list, name: "Zadanie 1", status: :pending)
    create(:task, todo_list: todo_list, name: "Zadanie 2", status: :in_progress)
    create(:task, todo_list: todo_list, name: "Zadanie 3", status: :on_hold)
    create(:task, todo_list: todo_list, name: "Zadanie 4", status: :completed)
    create(:task, todo_list: todo_list, name: "Zadanie przypisane", status: :pending, assignee: user)
  end

  scenario "Zwykły użytkownik widzi tablicę Kanban", js: true do
    sign_in user
    visit kanban_index_path

    expect(page).to have_content("Tablica Kanban")

    # Sprawdź czy wszystkie kolumny są widoczne
    expect(page).to have_content("Oczekujące")
    expect(page).to have_content("W trakcie")
    expect(page).to have_content("Wstrzymane")
    expect(page).to have_content("Zakończone")

    # Sprawdź czy zadania są widoczne
    expect(page).to have_content("Zadanie 1")
    expect(page).to have_content("Zadanie 2")
    expect(page).to have_content("Zadanie 3")
    expect(page).to have_content("Zadanie 4")
    expect(page).to have_content("Zadanie przypisane")
  end

  scenario "Kierownik projektu widzi wszystkie zadania projektu", js: true do
    sign_in project_manager
    visit kanban_index_path

    # Sprawdź czy wszystkie zadania są widoczne
    expect(page).to have_content("Zadanie 1")
    expect(page).to have_content("Zadanie 2")
    expect(page).to have_content("Zadanie 3")
    expect(page).to have_content("Zadanie 4")
    expect(page).to have_content("Zadanie przypisane")
  end

  scenario "Użytkownik wybiera projekt z listy filtrowania", js: true do
    # Utwórz drugi projekt z zadaniami
    other_project_manager = create(:user, :project_manager, company: company)
    other_project = build(:project, company: company)
    other_project.project_manager = other_project_manager
    other_project.save!

    create(:project_member, project: other_project, user: user)
    todo_list = create(:todo_list, project: other_project)
    create(:task, todo_list: todo_list, name: "Zadanie innego projektu", status: :pending)

    sign_in user
    visit kanban_index_path

    # Powinny być widoczne zadania z obu projektów
    expect(page).to have_content("Zadanie 1")
    expect(page).to have_content("Zadanie innego projektu")

    # Wybierz pierwszy projekt z listy
    select project.name, from: 'project_id'
    # Ponieważ formularz wysyła się automatycznie po zmianie, nie musimy klikać przycisku

    # Poczekaj na zakończenie żądania AJAX
    sleep(1)

    # Powinny być widoczne tylko zadania z pierwszego projektu
    expect(page).to have_content("Zadanie 1")
    expect(page).not_to have_content("Zadanie innego projektu")
  end

  scenario "Kliknięcie na zadanie otwiera modal ze szczegółami", js: true do
    sign_in user
    visit kanban_index_path

    # Kliknij na zadanie
    find('.task-card', text: 'Zadanie 1').click

    # Sprawdź czy modal się otworzył
    within('#task-modal') do
      expect(page).to have_content("Szczegóły zadania")
      expect(page).to have_button("Zamknij")
      expect(page).to have_link("Pełne szczegóły")
    end
  end
end
