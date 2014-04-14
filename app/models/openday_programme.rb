class OpendayProgramme < ActiveRecord::Base
  # Relations
  belongs_to :programme
  belongs_to :openday_faculty
  has_many :openday_timeslots, dependent: :destroy

  # Delete cached
  after_save :expire_opendays_cache
  after_destroy :expire_opendays_cache

  # Check if openday programme is configured
  def ready?
    if self.openday_timeslots.count < 1
      return false
    end
    return true
  end

private
  def expire_opendays_cache
    if(File.exists?(Openday::INDEX_CAHCE))
      File.delete(Openday::INDEX_CAHCE)
    end
  end
end
