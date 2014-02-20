class AddSlugToOpenday < ActiveRecord::Migration
  def change
    add_column :opendays, :slug, :string
  end
end
