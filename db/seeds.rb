# Set administrative user username and password
# This will be used to log in to system
username = "admin"
password = "password"


puts "Creating admins"
admin = Admin.new(username: username, password: password, password_confirmation: password)
admin.save!