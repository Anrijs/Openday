class AddEmailToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :email, :string, :after => :username
  end
end
