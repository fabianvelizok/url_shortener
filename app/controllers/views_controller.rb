class ViewsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_link, only: [ :show ]

  def show
    # Validate URL before redirecting
    safe_url = validate_and_sanitize_url(@link.url)

    @link.views.create!(ip: request.ip, user_agent: request.user_agent, referrer: request.referer)
    redirect_to safe_url, allow_other_host: true
  end

  private

  def set_link
    @link = Link.find_by_id_param!(params[:id])
  rescue ArgumentError
    raise ActiveRecord::RecordNotFound
  end

  def validate_and_sanitize_url(url)
    # Parse URL to ensure it's valid
    parsed_url = URI.parse(url)

    # Only allow http/https protocols
    unless %w[http https].include?(parsed_url.scheme)
      raise URI::InvalidURIError, "Invalid protocol"
    end

    # Return the original URL if valid
    url
  rescue URI::InvalidURIError
    # Fallback to a safe default if URL is invalid
    root_url
  end
end
