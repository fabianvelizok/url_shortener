class AddUniqueViewsCountToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :unique_views_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE links
          SET unique_views_count = (
            SELECT COUNT(DISTINCT ip)
            FROM views
            WHERE views.link_id = links.id
          )
        SQL
      end
    end
  end
end
