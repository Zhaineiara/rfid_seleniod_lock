class AddDeletedAtToTimetracks < ActiveRecord::Migration[7.0]
  def change
    add_column :time_tracks, :deleted_at, :datetime
  end
end
