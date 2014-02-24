class AddDescriptionToProgrammes < ActiveRecord::Migration
  def change
    add_column :programmes, :description, :text
  end
end
