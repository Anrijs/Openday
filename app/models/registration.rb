class Registration < ActiveRecord::Base
	# Relations
	belongs_to :registrant
	belongs_to :openday
    belongs_to :faculty
    belongs_to :programme
end
