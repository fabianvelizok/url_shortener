class ViewsController < ApplicationController
  def show
    redirect_to @link.url, allow_other_host: true
  end
end
