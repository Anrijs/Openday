class Registrant < ActiveRecord::Base
	has_many :registrations, dependent: :destroy
	belongs_to :openday
end
