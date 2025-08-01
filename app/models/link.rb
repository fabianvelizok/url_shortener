class Link < ApplicationRecord
  belongs_to :user
  has_many :views, dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }
  scope :by_id_param, ->(id) { where(id: Base62.decode(id.to_s)) }

  before_validation :strip_url

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  after_save_commit if: :url_previously_changed? do
    MetadataJob.perform_later(to_param)
  end

  def to_param
    Base62.encode(id)
  end

  def self.find_by_id_param!(id)
    by_id_param(id).take!
  end

  def domain
    URI(url).host
  end

  def strip_url
    self.url = url&.strip
  end

  def has_metadata?
    title || description || image
  end
end
