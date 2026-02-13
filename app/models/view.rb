class View < ApplicationRecord
  belongs_to :link, counter_cache: true

  scope :ordered, -> { order(created_at: :desc) }

  after_create :increment_unique_views_if_new_ip

  private

  def increment_unique_views_if_new_ip
    if link.views.where(ip: ip).count == 1
      link.increment!(:unique_views_count)
    end
  end
end
