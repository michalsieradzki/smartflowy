company = Company.instance

# Admin user
User.create!(
  email: 'admin@smartflowy.com',
  password: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  role: :superadmin,
  company: company
)

puts "Admin user created: admin@smartflowy.com / password123"
