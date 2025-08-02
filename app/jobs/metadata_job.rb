class MetadataJob < ApplicationJob
  queue_as :default

  def perform(id)
    link = Link.find_by_id_param!(id)
    metadata = Metadata.retrieve_from(link.url)

    if link.update(metadata.attributes)
      link.broadcast_replace_to([ link.user, "links" ])
    end
  rescue => e
    Rails.logger.error "MetadataJob failed for Link ID #{id}: #{e.message}"
  end
end
