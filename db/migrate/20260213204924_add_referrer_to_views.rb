class AddReferrerToViews < ActiveRecord::Migration[8.0]
  def change
    add_column :views, :referrer, :string
  end
end
