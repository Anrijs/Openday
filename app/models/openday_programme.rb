class OpendayProgramme < ActiveRecord::Base
  # Relations
  belongs_to :programme
  belongs_to :openday_faculty
  has_many :openday_timeslots, dependent: :destroy

  # Check if openday programme is configured
  def ready?
    if self.openday_timeslots.count < 1
      return false
    end
    return true
  end
end
