class Taglink < ActiveRecord::Base
  belongs_to :blog
  belongs_to :tag
  validates_uniqueness_of :tag_id, :scope => :blog_id
end
