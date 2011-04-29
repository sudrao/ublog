class AddSolrToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :in_solr, :integer
    add_index 'blogs', 'in_solr', :name => "in_solr_index"
  end

  def self.down
    remove_index 'blogs', :name => "in_solr_index"
    remove_column :blogs, :in_solr
  end
end
