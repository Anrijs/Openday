class Registrant < ActiveRecord::Base
  has_many :registrations, dependent: :destroy
  belongs_to :openday

  validates :name, presence: {message: I18n.t('validation.name_uniqueness')}
  validates :surname, presence: {message: I18n.t('validation.surname_uniqueness')}

  validates :email, presence: true, :email_format => {:message => I18n.t('validation.email_format')}

  validates :address1, presence: {message: I18n.t('validation.surname_uniqueness')}
  validates :address2, presence: {message: I18n.t('validation.surname_uniqueness')}
  validates :city, presence: {message: I18n.t('validation.surname_uniqueness')}
  validates :state, presence: {message: I18n.t('validation.surname_uniqueness')}
  validates :country, presence: {message: I18n.t('validation.surname_uniqueness')}
  validates :postal_code, presence: {message: I18n.t('validation.surname_uniqueness')}
  validates :companions, presence: {message: I18n.t('validation.surname_uniqueness')}
  validates :year, presence: {message: I18n.t('validation.surname_uniqueness')}
  

  def check_programmes programmes
    if programmes.nil?
      errors.add("programmes", "Select 1+")
    end

  end
end
