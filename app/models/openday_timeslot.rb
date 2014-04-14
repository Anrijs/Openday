class OpendayTimeslot < ActiveRecord::Base
  # Relations
  belongs_to :openday_programme

  #Validations
  validates_presence_of :time_from, message: I18n.t('validation.time_presence')
  validates_presence_of :time_till, message: I18n.t('validation.time_presence')
  validates_time :time_from, :before => :time_till

  # Delete cached
  after_save :expire_opendays_cache
  after_destroy :expire_opendays_cache

private
  def expire_opendays_cache
    if(File.exists?(Openday::INDEX_CAHCE))
      File.delete(Openday::INDEX_CAHCE)
    end
  end
end