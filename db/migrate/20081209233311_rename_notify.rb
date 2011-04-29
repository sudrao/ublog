class RenameNotify < ActiveRecord::Migration
  def self.up
    rename_column :homes, :notify, :notify_calendar
  end

  def self.down
    rename_column :homes, :notify_calendar, :notify
  end
end
