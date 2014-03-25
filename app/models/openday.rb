class Openday < ActiveRecord::Base

  has_many :openday_faculties, dependent: :destroy
  has_many :registrants
  has_many :registrations
  
  validates_datetime :registration_open
  validates_datetime :registration_end
  validates_datetime :registration_open, :before => :registration_end
  validates_datetime :date, :after => :registration_open
  validates_date :date

  validates_presence_of :name, message: I18n.t('validation.name_presence')
  validates_uniqueness_of :name, message: I18n.t('validation.name_uniqueness')
  validates_uniqueness_of :slug, message: I18n.t('validation.name_uniqueness')


  before_validation :create_slug

  def self.find_active
    Openday.where('registration_open <= :time AND registration_end >= :time', {:time =>  DateTime.now})
  end

  def active?
    time = DateTime.now
    if (self.registration_open <= time && self.registration_end >= time)
      return true
    else
      return false
    end
  end

  def ready?
    self.openday_faculties.each do |faculty|
      if faculty.openday_programmes.count < 1
        return false
      end
      faculty.openday_programmes.each do |programme|
        if programme.openday_timeslots.count < 1
          return false
        end
      end
    end
    return true
  end

  def report_registrants
    return Registrant.find(:all, 
      select: 'count(*) count, DAYOFYEAR(created_at) as date', 
      group: "DAYOFYEAR(created_at)", 
      conditions: ['openday_id = ?', self.id], 
      order: 'DAYOFYEAR(created_at) ASC'
    )
  end

  def report_registrations
    faculties = {}
    self.openday_faculties.each do |faculty|
      faculties[faculty.faculty.name] = Registration.find(:all, 
        select: 'count(*) count, DAYOFYEAR(created_at) as date', 
        group: "DAYOFYEAR(created_at)", 
        conditions: ['openday_id = ? AND faculty_id = ?', self.id, faculty.faculty.id], 
        order: 'DAYOFYEAR(created_at) ASC'
      )
    end
    return faculties
  end


  def report_countries
    return Registrant.find(:all, 
        select: 'count(*) count, country', 
        group: 'country', 
        conditions: ['openday_id = ?', self.id], 
        order: 'count DESC'
    )
  end

  def range_days
    range = {}
    ranges = Openday.find(self.id, 
      select: 'DAYOFYEAR(registration_open) as day_open, DAYOFYEAR(registration_end) as day_end')
    range[:start] = ranges.day_open
    range[:end] = ranges.day_end
    return range 
  end

private
  def create_slug
    self.slug = self.name.to_s.parameterize
  end
end
