module PaginationHelper
  def pagination_for(pagy)
    render("shared/pagination", pagy:)
  end
end
