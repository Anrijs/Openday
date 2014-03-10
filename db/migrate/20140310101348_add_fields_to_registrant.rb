class AddFieldsToRegistrant < ActiveRecord::Migration
  def change
  	add_column :registrants, :companions, :integer
  	add_column :registrants, :visited, :boolean
  end
end
