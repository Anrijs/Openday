class OpendayProgramme < ActiveRecord::Base
  belongs_to :programme
  belongs_to :openday_faculty
  has_many :openday_timeslots

  def ready?
    if self.openday_timeslots.count < 1
      return false
    end
    return true
  end
end
