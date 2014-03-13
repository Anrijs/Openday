class Registration < ActiveRecord::Base
	belongs_to :registrant
	belongs_to :openday
    belongs_to :faculty
    belongs_to :programme
end
