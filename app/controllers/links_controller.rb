class LinksController < ApplicationController
  before_action :set_link, only: [ :show ]

  def index
    @links = current_user.links
    @link = Link.new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      redirect_to root_path, notice: "Link was successfully created."
    else
      @links = current_user.links
      render :index, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end

  def set_link
    @link = current_user.links.find_by(id: Base62.decode(params[:id]))
  end
end
