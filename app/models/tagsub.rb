class Tagsub < ActiveRecord::Base
  belongs_to :home
  belongs_to :tag
  validates_uniqueness_of :tag_id, :scope => :home_id
end
