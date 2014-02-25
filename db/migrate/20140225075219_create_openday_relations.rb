class CreateOpendayRelations < ActiveRecord::Migration
  def change
    create_table :openday_faculties do |t|
      t.integer :openday_id
      t.integer :faculty_id
    end

    create_table :openday_programmes do |t|
      t.integer :openday_faculty_id
      t.integer :programme_id
    end

    create_table :openday_timeslots do |t|
      t.integer :openday_programme_id
      t.time :time_from
      t.time :time_till
      t.integer :capacity
    end
  end
end
