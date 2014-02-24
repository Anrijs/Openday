class Faculty < ActiveRecord::Base
  has_many :programmes, dependent: :destroy

  validates_presence_of :name, message: I18n.t('validation_name_presence')
  validates_uniqueness_of :name, message: I18n.t('validation_name_uniqueness')

  validates_presence_of :short_name, message: I18n.t('validation_short_name_presence')
  validates_uniqueness_of :short_name, message: I18n.t('validation_short_name_uniqueness')
  
  validates_uniqueness_of :slug, message: I18n.t('validation_name_uniqueness')


  before_validation :create_slug

private
  def create_slug
    self.slug = self.short_name.parameterize
  end
end
