class AddOpendayIdToRegistrations < ActiveRecord::Migration
  def change
  	add_column :registrations, :openday_id, :integer
  end
end
