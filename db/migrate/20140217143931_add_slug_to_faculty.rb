class AddSlugToFaculty < ActiveRecord::Migration
  def change
    add_column :faculties, :slug, :string
  end
end
