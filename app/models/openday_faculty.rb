class OpendayFaculty < ActiveRecord::Base
  belongs_to :openday
  belongs_to :faculty
  has_many :openday_programmes, dependent: :destroy

  def ready?
  	unless @ready
      self.openday_programmes.each do |programme|
        if programme.openday_timeslots.count < 1
          @ready = false
          return false
        end
      end
      @ready = true
      return true
    else 
      return @ready
    end
  end
end
