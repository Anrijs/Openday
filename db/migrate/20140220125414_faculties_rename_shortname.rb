class FacultiesRenameShortname < ActiveRecord::Migration
    def change
    rename_column :faculties, :shortname, :short_name
  end
end
