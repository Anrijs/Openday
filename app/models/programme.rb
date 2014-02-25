class Programme < ActiveRecord::Base
	belongs_to :faculty
	has_many :openday_programmes

	before_validation :create_slug

private
  def create_slug
    self.slug = self.name.parameterize
  end
end
