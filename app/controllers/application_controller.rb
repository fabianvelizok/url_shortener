class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_link, only: [ :show ]

  private

  def set_link
    @link = current_user.links.find_by_id_param!(params[:id])
  rescue ArgumentError, NoMethodError
    raise ActiveRecord::RecordNotFound
  end
end
