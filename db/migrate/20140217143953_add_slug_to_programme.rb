class AddSlugToProgramme < ActiveRecord::Migration
  def change
    add_column :programmes, :slug, :string
  end
end
