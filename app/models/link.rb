class Link < ApplicationRecord
  belongs_to :user
  has_many :views, dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }
  scope :by_id_param, ->(id) { where(id: Base62.decode(id.to_s)) }

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  def to_param
    Base62.encode(id)
  end

  def self.find_by_id_param!(id)
    by_id_param(id).take!
  end
end
