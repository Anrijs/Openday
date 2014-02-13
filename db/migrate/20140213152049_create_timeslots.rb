class CreateTimeslots < ActiveRecord::Migration
  def change
    create_table :timeslots do |t|
      t.integer :programme_id
      t.integer :openday_id
      t.time :time_from
      t.time :time_till
      t.integer :capacity

      t.timestamps
    end
  end
end
