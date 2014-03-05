class AddOpendayIdToRegistrants < ActiveRecord::Migration
  def change
    add_column :registrants, :openday_id, :integer
  end
end
