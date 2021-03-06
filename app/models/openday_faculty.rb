class OpendayFaculty < ActiveRecord::Base
  belongs_to :openday
  belongs_to :faculty
  has_many :openday_programmes, dependent: :destroy

  # Delete cached
  after_save :expire_registration_cache
  after_destroy :expire_registration_cache

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
          .where('registrations.openday_id = ? AND faculty_id = ?', self.openday_id, self.faculty_id)
          .order('count DESC')
  end

  def report_timeslots
    timeslots = {}
    self.openday_programmes.each do |programme|
      query = (OpendayTimeslot.select('*, Count(registrations.timeslot_id) count')
          .group('openday_timeslots.id')
          .joins('LEFT JOIN registrations ON openday_timeslots.id = registrations.timeslot_id')
          .where('openday_programme_id = ?', programme.id)
          .order('count DESC'))
      timeslots[programme.programme.name] = query
    end
    return timeslots
  end

private
  def expire_registration_cache
    CONFIG['locales'].each do |locale|
      if(File.exists?(Registrant::CACHE_DIR+self.openday.slug+'_'+locale.first))
        File.delete(Registrant::CACHE_DIR+self.openday.slug+'_'+locale.first)
      end
    end
  end
end