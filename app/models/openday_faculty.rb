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

  # Get all registrations for faculty grouped
  #

  def report_registrants
    return Registration.select('*, count(DISTINCT registrant_id) as count, DAYOFYEAR(registrants.created_at) as date')
          .group('DAYOFYEAR(registrants.created_at)')
          .joins('INNER JOIN registrants ON registrations.registrant_id = registrants.id')
          .where('faculty_id = ?', self.faculty_id)
          .order('DAYOFYEAR(registrants.created_at) ASC')
  end

  def report_registrations
    programmes = {}
    self.openday_programmes.each do |programme|
      programmes[programme.programme.name] = Registration.find(:all, 
        select: 'count(*) count, DAYOFYEAR(created_at) as date', 
        group: "DAYOFYEAR(created_at)", 
        conditions: ['openday_id = ? AND programme_id = ?', self.openday_id, programme.programme_id], 
        order: 'DAYOFYEAR(created_at) ASC'
      )
    end
    return programmes
  end

  def report_countries
    return Registration.select('*, count(DISTINCT registrant_id) as count')
          .group('registrants.country')
          .joins('INNER JOIN registrants ON registrations.registrant_id = registrants.id')
          .where('faculty_id = ?', self.faculty_id)
          .order('count DESC')
  end

end
