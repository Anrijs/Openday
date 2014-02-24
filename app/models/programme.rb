class Programme < ActiveRecord::Base
	belongs_to :faculty

	before_validation :create_slug

private
  def create_slug
    self.slug = self.name.parameterize
  end
end
