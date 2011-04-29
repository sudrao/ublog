class RemoveNulls < ActiveRecord::Base
  # Get rid of bad blogs (not usually required)
  def self.rem
    Blog.delete_all('home_id IS NULL')
  end
end
