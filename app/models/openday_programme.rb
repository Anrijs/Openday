class OpendayProgramme < ActiveRecord::Base
  # Relations
  belongs_to :programme
  belongs_to :openday_faculty
  has_many :openday_timeslots, dependent: :destroy

  # Delete cached
  after_save :expire_registration_cache
  after_destroy :expire_registration_cache

  # Check if openday programme is configured
  def ready?
    if self.openday_timeslots.count < 1
      return false
    end
    return true
  end

private
  def expire_registration_cache
    CONFIG['locales'].each do |locale|
      if(File.exists?(Registrant::CACHE_DIR+self.openday_faculty.openday.slug+'_'+locale.first))
        File.delete(Registrant::CACHE_DIR+self.openday_faculty.openday.slug+'_'+locale.first)
      end
    end
  end
end
