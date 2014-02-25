class OpendayProgramme < ActiveRecord::Base
  belongs_to :programme
  belongs_to :openday_faculty
  has_many :openday_timeslots
end
