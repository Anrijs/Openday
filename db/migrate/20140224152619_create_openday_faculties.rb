class CreateOpendayFaculties < ActiveRecord::Migration
  def change
    create_table :openday_faculties do |t|
      t.integer :faculty_id
      t.integer :openday_id

      t.timestamps
    end
  end
end
