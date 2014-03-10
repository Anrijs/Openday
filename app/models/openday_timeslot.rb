class OpendayTimeslot < ActiveRecord::Base
  belongs_to :openday_programme

  validates_presence_of :time_from, message: I18n.t('validation.time_presence')
  validates_presence_of :time_till, message: I18n.t('validation.time_presence')

  validates_time :time_from, :before => :time_till

end