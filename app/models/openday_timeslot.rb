class OpendayTimeslot < ActiveRecord::Base
  # Relations
  belongs_to :openday_programme

  #Validations
  validates_presence_of :time_from, message: I18n.t('validation.time_presence')
  validates_presence_of :time_till, message: I18n.t('validation.time_presence')
  validates_time :time_from, :before => :time_till

  # Delete cached
  after_save :expire_opendays_cache
  after_save :expire_registration_cache
  after_destroy :expire_opendays_cache
  after_destroy :expire_registration_cache

private
  def expire_opendays_cache
    if(File.exists?(Openday::INDEX_CAHCE))
      File.delete(Openday::INDEX_CAHCE)
    end
  end

  def expire_registration_cache 
    if(File.exists?(Registrant::CACHE_DIR+self.openday_programme.openday_faculty.openday.slug))
      File.delete(Registrant::CACHE_DIR+self.openday_programme.openday_faculty.openday.slug)
    end
  end
end