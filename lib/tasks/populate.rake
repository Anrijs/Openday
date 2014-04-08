namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    cycles = 1000
    countries = ['lv', 'lt', 'ee', 'nl', 'de', 'gb', 'us', 'hk', 'dm']

    (1..cycles).each do |i|
      puts "populating cycle 1: #{(i/10).to_s}%"
      od = Openday.first

      tf = od.registration_open
      tt = od.registration_end
      
      e = Faker::Internet.email
      c = countries.sample
      t = Time.at(tf + rand * (tt.to_f - tf.to_f))
      n = Faker::Name.first_name
      s = Faker::Name.last_name
      
      u = Registrant.create!(name: n, surname: s, email: e, address1: "a", address2: "b", city: "city", state: "state", country: c, postal_code: "LV1000", year: "2015", created_at: t, updated_at: t, openday_id: od.id, companions: 0)
      
      fa = od.openday_faculties.sample
      fid = fa.faculty.id
      pa = fa.openday_programmes.sample
      pid = pa.programme.id
      ta = pa.openday_timeslots.sample
      tid = ta.id
      Registration.create!(registrant_id: u.id, timeslot_id: tid, created_at: t, updated_at: t, openday_id: od.id, faculty_id: fid, programme_id: pid)
      
      fa = od.openday_faculties.sample
      fid = fa.faculty.id
      pa = fa.openday_programmes.sample
      pid = pa.programme.id
      ta = pa.openday_timeslots.sample
      tid = ta.id
      Registration.create!(registrant_id: u.id, timeslot_id: tid, created_at: t, updated_at: t, openday_id: od.id, faculty_id: fid, programme_id: pid)
      
      fa = od.openday_faculties.sample
      fid = fa.faculty.id
      pa = fa.openday_programmes.sample
      pid = pa.programme.id
      ta = pa.openday_timeslots.sample
      tid = ta.id
      Registration.create!(registrant_id: u.id, timeslot_id: tid, created_at: t, updated_at: t, openday_id: od.id, faculty_id: fid, programme_id: pid)
    end

    (1..cycles).each do |i|
      puts "populating cycle 2: #{(i/10).to_s}%"
      od = Openday.last

      tf = od.registration_open
      tt = od.registration_end
      
      e = Faker::Internet.email
      c = countries.sample
      t = Time.at(tf + rand * (tt.to_f - tf.to_f))
      n = Faker::Name.first_name
      s = Faker::Name.last_name
      
      u = Registrant.create!(name: n, surname: s, email: e, address1: "a", address2: "b", city: "city", state: "state", country: c, postal_code: "LV1000", year: "2015", created_at: t, updated_at: t, openday_id: od.id, companions: 0)
      
      fa = od.openday_faculties.sample
      fid = fa.faculty.id
      pa = fa.openday_programmes.sample
      pid = pa.programme.id
      ta = pa.openday_timeslots.sample
      tid = ta.id
      Registration.create!(registrant_id: u.id, timeslot_id: tid, created_at: t, updated_at: t, openday_id: od.id, faculty_id: fid, programme_id: pid)
      
      fa = od.openday_faculties.sample
      fid = fa.faculty.id
      pa = fa.openday_programmes.sample
      pid = pa.programme.id
      ta = pa.openday_timeslots.sample
      tid = ta.id
      Registration.create!(registrant_id: u.id, timeslot_id: tid, created_at: t, updated_at: t, openday_id: od.id, faculty_id: fid, programme_id: pid)
      
      fa = od.openday_faculties.sample
      fid = fa.faculty.id
      pa = fa.openday_programmes.sample
      pid = pa.programme.id
      ta = pa.openday_timeslots.sample
      tid = ta.id
      Registration.create!(registrant_id: u.id, timeslot_id: tid, created_at: t, updated_at: t, openday_id: od.id, faculty_id: fid, programme_id: pid)
    end
  end
end