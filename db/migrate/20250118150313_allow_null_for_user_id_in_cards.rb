class AllowNullForUserIdInCards < ActiveRecord::Migration[7.0]
  def change
    change_column_null :cards, :user_id, true
  end
end
