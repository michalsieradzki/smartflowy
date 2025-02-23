
puts "Czyszczenie bazy..."
Comment.delete_all
Task.delete_all
TodoList.delete_all
Project.delete_all
User.delete_all
Company.delete_all

# Tworzenie firm
puts "Tworzenie firm..."
company1 = Company.create!(name: "Firma Software House", description: "Duża firma IT")
company2 = Company.create!(name: "StartUp Tech", description: "Innowacyjny startup")

# Tworzenie użytkowników
puts "Tworzenie użytkowników..."

# Firma 1
superadmin = User.create!(
 email: 'superadmin@example.com',
 password: 'password123',
 first_name: 'Super',
 last_name: 'Admin',
 role: :superadmin,
 company: company1,
 position: 'Chief Technology Officer'
)

company1_admin = User.create!(
 email: 'admin1@example.com',
 password: 'password123',
 first_name: 'Jan',
 last_name: 'Kowalski',
 role: :company_admin,
 company: company1,
 position: 'Project Director'
)

# Project Managers dla Firma 1
pm1 = User.create!(
 email: 'pm1@example.com',
 password: 'password123',
 first_name: 'Anna',
 last_name: 'Nowak',
 role: :project_manager,
 company: company1,
 position: 'Senior Project Manager'
)

pm2 = User.create!(
 email: 'pm2@example.com',
 password: 'password123',
 first_name: 'Piotr',
 last_name: 'Wiśniewski',
 role: :project_manager,
 company: company1,
 position: 'Project Manager'
)

# Zwykli użytkownicy dla Firma 1
10.times do |i|
 User.create!(
   email: "user#{i+1}@example.com",
   password: 'password123',
   first_name: Faker::Name.first_name,
   last_name: Faker::Name.last_name,
   role: :user,
   company: company1,
   position: ['Developer', 'Designer', 'Tester', 'Analyst'].sample
 )
end

# Firma 2
company2_admin = User.create!(
 email: 'admin2@example.com',
 password: 'password123',
 first_name: 'Marek',
 last_name: 'Adamski',
 role: :company_admin,
 company: company2,
 position: 'CEO'
)

pm3 = User.create!(
 email: 'pm3@example.com',
 password: 'password123',
 first_name: 'Kasia',
 last_name: 'Lewandowska',
 role: :project_manager,
 company: company2,
 position: 'Project Manager'
)

5.times do |i|
 User.create!(
   email: "startup_user#{i+1}@example.com",
   password: 'password123',
   first_name: Faker::Name.first_name,
   last_name: Faker::Name.last_name,
   role: :user,
   company: company2,
   position: ['Developer', 'Designer', 'Marketing'].sample
 )
end

# Tworzenie projektów i zadań dla Firma 1
puts "Tworzenie projektów dla Firma 1..."

# Projekt 1: Duży projekt webowy
project1 = Project.create!(
 name: "Portal E-commerce",
 description: "Rozbudowany portal dla dużej sieci sklepów",
 company: company1,
 project_manager: pm1
)

# Todo listy dla projektu 1
["Backend tasks", "Frontend tasks", "Testing"].each do |list_name|
 todo_list = TodoList.create!(
   name: list_name,
   project: project1
 )

 # Tasks dla każdej listy
 4.times do |i|
   task = Task.create!(
     name: "#{list_name} - Task #{i+1}",
     description: Faker::Lorem.paragraph,
     todo_list: todo_list,
     status: Task.statuses.keys.sample,
     assignee: company1.users.sample,
     due_date: rand(1..30).days.from_now
   )

   # Komentarze do zadań
   2.times do
     Comment.create!(
       content: Faker::Lorem.paragraph,
       user: company1.users.sample,
       commentable: task
     )
   end
 end
end

# Projekt 2: Aplikacja mobilna
project2 = Project.create!(
 name: "Aplikacja Mobilna",
 description: "Aplikacja do zarządzania czasem",
 company: company1,
 project_manager: pm2
)

["Design", "Development", "QA"].each do |list_name|
 todo_list = TodoList.create!(
   name: list_name,
   project: project2
 )

 3.times do |i|
   task = Task.create!(
     name: "#{list_name} - Task #{i+1}",
     description: Faker::Lorem.paragraph,
     todo_list: todo_list,
     status: Task.statuses.keys.sample,
     assignee: company1.users.sample,
     due_date: rand(1..30).days.from_now
   )

   rand(1..3).times do
     Comment.create!(
       content: Faker::Lorem.paragraph,
       user: company1.users.sample,
       commentable: task
     )
   end
 end
end

# Tworzenie projektów dla Firma 2
puts "Tworzenie projektów dla Firma 2..."

project3 = Project.create!(
 name: "Aplikacja SaaS",
 description: "Innowacyjne rozwiązanie SaaS dla małych firm",
 company: company2,
 project_manager: pm3
)

["Planning", "MVP Development", "Marketing"].each do |list_name|
 todo_list = TodoList.create!(
   name: list_name,
   project: project3
 )

 3.times do |i|
   task = Task.create!(
     name: "#{list_name} - Task #{i+1}",
     description: Faker::Lorem.paragraph,
     todo_list: todo_list,
     status: Task.statuses.keys.sample,
     assignee: company2.users.sample,
     due_date: rand(1..30).days.from_now
   )

   rand(1..2).times do
     Comment.create!(
       content: Faker::Lorem.paragraph,
       user: company2.users.sample,
       commentable: task
     )
   end
 end
end

puts "Seed zakończony pomyślnie!"
