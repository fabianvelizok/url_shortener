class Link < ApplicationRecord
  belongs_to :user

  scope :ordered, -> { order(created_at: :desc) }

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  def to_param
    Base62.encode(id)
  end
end
