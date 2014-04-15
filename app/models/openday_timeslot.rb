class OpendayTimeslot < ActiveRecord::Base
  # Relations
  belongs_to :openday_programme

  #Validations
  validates_presence_of :time_from, message: I18n.t('validation.time_presence')
  validates_presence_of :time_till, message: I18n.t('validation.time_presence')
  validates_time :time_from, :before => :time_till

  # Delete cached
  after_save :expire_registration_cache
  after_destroy :expire_registration_cache

private
  def expire_registration_cache 
    CONFIG['locales'].each do |locale|
      if(File.exists?(Registrant::CACHE_DIR+self.openday_programme.openday_faculty.openday.slug+'_'+locale.first))
        File.delete(Registrant::CACHE_DIR+self.openday_programme.openday_faculty.openday.slug+'_'+locale.first)
      end
    end
  end
end