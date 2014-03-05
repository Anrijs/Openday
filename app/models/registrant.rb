class Registrant < ActiveRecord::Base
	has_many :registrations
	belongs_to :openday
end
