class AddDescriptionAndUrlToFaculties < ActiveRecord::Migration
  def change
    add_column :faculties, :description, :text
    add_column :faculties, :url, :string
    add_column :programmes, :url, :string
  end
end
