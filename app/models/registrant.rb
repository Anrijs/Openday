class Registrant < ActiveRecord::Base

  CACHE_DIR = "public/cache/registrations/"

  # Relations
  has_many :registrations, dependent: :destroy
  belongs_to :openday

  # Validations
  validates :name, presence: {message: I18n.t('validation.name_presence')}
  validates :surname, presence: {message: I18n.t('validation.surname_presence')}
  validates :email, :email_format => {:message => I18n.t('validation.email_format')}
  validates :address1, presence: {message: I18n.t('validation.address1_presence')}
  validates :address2, presence: {message: I18n.t('validation.address2_presence')}
  validates :city, presence: {message: I18n.t('validation.city_presence')}
  validates :state, presence: {message: I18n.t('validation.state_presence')}
  validates :country, presence: {message: I18n.t('validation.country_presence')}
  validates :postal_code, presence: {message: I18n.t('validation.postal_code_presence')}
  validates :companions, presence: {message: I18n.t('validation.companions_presence')}
  validates :year, presence: {message: I18n.t('validation.year_presence')}
  
  # Check if registrant programmes are selected correctly
  def check_programmes programmes
    if programmes.nil?
      errors.add("registration", I18n.t('validation.not_enough', count: CONFIG['registration']['limit_min']))
    else
      if programmes.count > CONFIG['registration']['limit_max']
        errors.add("registration", I18n.t('validation.too_many', count: CONFIG['registration']['limit_max']))
      end
      size_before = errors.count
      programmes.each do |key, programme|
        if programme == "0" 
          errors.add("programme[#{key}]", I18n.t('validation.missing_timeslot_for', programme: OpendayProgramme.find(key).programme.name))
        end
      end
      if errors.count > size_before
        #errors.add("registration", I18n.t('validation.registrations.missing_data'))
      end
    end
  end
end
