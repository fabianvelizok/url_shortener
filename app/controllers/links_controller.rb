class LinksController < ApplicationController
  before_action :set_link, only: [ :show, :edit, :update ]

  def index
    @links = current_user.links
    @link ||= Link.new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      redirect_to root_path, notice: "Link was successfully created."
    else
      index
      render :index, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @link.update(link_params)
      redirect_to @link, notice: "Link was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
