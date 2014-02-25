# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Creating admins"
admin = Admin.new(username: "admin", password: "password", 	password_confirmation: "password")
admin.save!

puts "Creating openday template"
@od = Openday.new(name: "Openday 2014", registration_open: "2014-02-19 00:00:00.000000", registration_end: "2014-02-28 00:00:00.000000", date: "2014-02-23")
@od.save

@od_f = Faculty.new(name: "Faculty of Rocket engineering", short_name: "FoRe")
@od_f.save

@od_p1 = Programme.new(name: "Rocket engines", faculty_id: @od_f.id)
@od_p2 = Programme.new(name: "Rocket aerodynamics", faculty_id: @od_f.id)
@od_p3 = Programme.new(name: "Advanced fueling systems", faculty_id: @od_f.id)
@od_p4 = Programme.new(name: "Rocket jumping", faculty_id: @od_f.id)

@od_p1.save
@od_p2.save
@od_p3.save
@od_p4.save

OpendayFaculty.new(openday_id: @od.id, faculty_id: @od_f.id)