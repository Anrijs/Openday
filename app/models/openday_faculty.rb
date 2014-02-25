class OpendayFaculty < ActiveRecord::Base
  belongs_to :openday
  belongs_to :faculty
  has_many :openday_programmes
end
