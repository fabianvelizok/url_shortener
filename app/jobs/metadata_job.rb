class MetadataJob < ApplicationJob
  queue_as :default

  def perform(id)
    link = Link.find_by_id_param!(id)
    link.update Metadata.retrieve_from(link.url).attributes
  end
end
