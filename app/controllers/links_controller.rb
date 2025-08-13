class LinksController < ApplicationController
  before_action :set_link, only: [ :show, :edit, :update, :destroy ]

  def index
    @pagy, @links = pagy(current_user.links)
    @link ||= Link.new
  rescue Pagy::OverflowError
    redirect_to root_path(page: 1)
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Link was successfully created." }
        format.turbo_stream { render turbo_stream: [
          turbo_stream.prepend("links", @link),
          turbo_stream.replace("link_form", partial: "links/form", locals: { model: Link.new })
        ] }
      end
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

  def destroy
    @link.destroy
    redirect_to root_path, notice: "Link was successfully deleted."
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
