class CreateRegistrants < ActiveRecord::Migration
  def change
    create_table :registrants do |t|
      t.string :name
      t.string :prefix
      t.string :surname
      t.string :email
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.integer :year

      t.timestamps
    end
  end
end
