class SetDefaultToViewsCount < ActiveRecord::Migration[8.0]
  def change
    change_column_default :links, :views_count, from: nil, to: 0
    Link.where(views_count: nil).update_all(views_count: 0)
  end
end
