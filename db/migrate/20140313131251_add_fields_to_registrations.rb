class AddFieldsToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :faculty_id, :integer
    add_column :registrations, :programme_id, :integer
  end
end
