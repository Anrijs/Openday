class Openday < ActiveRecord::Base

  has_many :timeslots, :dependent => :delete_all
  has_many :faculties
  has_many :programmes
  
  validates_datetime :registration_open
  validates_datetime :registration_end
  validates_datetime :registration_open, :before => :registration_end
  validates_datetime :date, :after => :registration_open
  validates_date :date

  validates_presence_of :name, message: I18n.t('validation_name_presence')
  validates_uniqueness_of :name, message: I18n.t('validation_name_uniqueness')
  validates_uniqueness_of :slug, message: I18n.t('validation_name_uniqueness')


  before_validation :create_slug

private
  def create_slug
    self.slug = self.name.parameterize
  end
end
