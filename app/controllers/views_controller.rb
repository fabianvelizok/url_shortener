class ViewsController < ApplicationController
  def show
    @link.views.create!(ip: request.ip, user_agent: request.user_agent)
    redirect_to @link.url, allow_other_host: true
  end
end
