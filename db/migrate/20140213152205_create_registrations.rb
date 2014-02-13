class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :registrant_id
      t.integer :timeslot_id

      t.timestamps
    end
  end
end
