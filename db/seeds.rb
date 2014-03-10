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
@od = Openday.create(name: "Openday 2014", registration_open: "2014-02-19 00:00:00.000000", registration_end: "2014-02-28 00:00:00.000000", date: "2014-02-23")

@od_f = Faculty.create(name: "Faculty of Rocket engineering", short_name: "FoRe")

@od_p1 = Programme.save(name: "Rocket engines", faculty_id: @od_f.id)
@od_p2 = Programme.save(name: "Rocket aerodynamics", faculty_id: @od_f.id)
@od_p3 = Programme.save(name: "Advanced fueling systems", faculty_id: @od_f.id)
@od_p4 = Programme.save(name: "Rocket jumping", faculty_id: @od_f.id)

@of = OpendayFaculty.create(openday_id: @od.id, faculty_id: @od_f.id)

@od_op1 = @of.openday_programmes.new(programme_id: @od_p1.id, openday_id: @od.id)
@od_op2 = @of.openday_programmes.new(programme_id: @od_p2.id, openday_id: @od.id)
@od_op3 = @of.openday_programmes.new(programme_id: @od_p3.id, openday_id: @od.id)
@od_op4 = @of.openday_programmes.new(programme_id: @od_p4.id, openday_id: @od.id)

