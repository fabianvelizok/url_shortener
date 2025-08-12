class ViewsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_link, only: [ :show ]

  def show
    @link.views.create!(ip: request.ip, user_agent: request.user_agent)
    redirect_to @link.url, allow_other_host: true
  end

  private

  def set_link
    @link = Link.find_by_id_param!(params[:id])
  rescue ArgumentError
    raise ActiveRecord::RecordNotFound
  end
end
