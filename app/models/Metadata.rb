require "nokogiri"
require "open-uri"

class Metadata
  attr_reader :doc

  def self.retrieve_from(url)
    new(URI.open(url))
  rescue
    new
  end

  def initialize(html = nil)
    @doc = Nokogiri::HTML(html)
  end

  def attributes
    {
      title:,
      description:,
      image:
    }
  end

  def title
    doc.title
  end

  def description
    content_for("meta[name='description']")
  end

  def image
    content_for("meta[property='og:image']")
  end

  private

  def content_for(property)
    node = doc.at(property)
    node ? node["content"] : nil
  end
end
