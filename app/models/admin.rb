class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  validates :email, :presence => false, :email => false
  validates :username, :presence => true, :uniqueness => true

  def email_required?
    false
  end
end
