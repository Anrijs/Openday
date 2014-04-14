class Programme < ActiveRecord::Base
  # Relations
  belongs_to :faculty
  has_many :openday_programmes
  has_many :registrations

  # Validations
  validates_presence_of :name, message: I18n.t('validation.name_presence')
  validate :validate_name
  before_validation :create_slug

  # Delete cached
  after_save :expire_opendays_cache
  after_save :expire_registration_cache
  after_destroy :expire_opendays_cache
  after_destroy :expire_registration_cache
private
  def create_slug
    self.slug = self.name.to_s.parameterize
  end

  def validate_name
  	#if name fount for faculty
    #errors.add I18n.t('validation.name_uniqueness')
  end

  def expire_opendays_cache
    CONFIG['locales'].each do |locale|
      if(File.exists?(Openday::INDEX_CAHCE+'_'+locale.first))
        File.delete(Openday::INDEX_CAHCE+'_'+locale.first)
      end
    end
  end

  def expire_registration_cache
    FileUtils.rm_rf(Registrant::CACHE_DIR)
  end
end
