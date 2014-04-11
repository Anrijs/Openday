class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :opendays, :id
  	add_index :faculties, :id
  	add_index :programmes, :id


  	add_index :openday_faculties, :id
  	add_index :openday_programmes, :id
  	add_index :openday_timeslots, :id

  	add_index :registrants, :id
  	add_index :registrations, :id

  end
end
