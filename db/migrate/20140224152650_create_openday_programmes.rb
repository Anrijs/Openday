class CreateOpendayProgrammes < ActiveRecord::Migration
  def change
    create_table :openday_programmes do |t|
      t.integer :faculty_id
      t.integer :openday_id

      t.timestamps
    end
  end
end
