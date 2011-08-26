class Tag < ActiveRecord::Base
  has_many :taglinks
  has_many :blogs, :through => :taglinks
  has_many :tagsubs
  has_many :homes, :through => :tagsubs
  
  validates_uniqueness_of :name

  acts_as_solr :fields => [:name]
  
end
