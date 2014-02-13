class CreateOpendays < ActiveRecord::Migration
  def change
    create_table :opendays do |t|
      t.string :name
      t.integer :year
      t.datetime :registration_open
      t.datetime :registration_end
      t.date :date

      t.timestamps
    end
  end
end
