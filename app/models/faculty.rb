class Faculty < ActiveRecord::Base
  has_many :programmes, dependent: :destroy
  has_many :openday_faculties, dependent: :destroy
  has_many :registrations

  validates_presence_of :name, message: I18n.t('validation.name_presence')
  validates_uniqueness_of :name, message: I18n.t('validation.name_uniqueness')

  validates_presence_of :short_name, message: I18n.t('validation.short_name_presence')
  validates_uniqueness_of :short_name, message: I18n.t('validation.short_name_uniqueness')
  
  validates_uniqueness_of :slug, message: I18n.t('validation.slug_uniqueness')


  before_validation :create_slug

private
  def create_slug
    self.slug = self.short_name.to_s.parameterize
  end
end
