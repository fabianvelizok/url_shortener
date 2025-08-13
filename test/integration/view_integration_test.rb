require "test_helper"

class ViewIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @link = links(:one)
  end

  test "public short URL redirects to original URL" do
    get view_path(@link)

    assert_response :redirect
    assert_redirected_to @link.url
  end

  test "accessing short URL creates a view record" do
    assert_difference "View.count", 1 do
      get view_path(@link)
    end

    # Check the view was recorded with correct data
    view = View.last
    assert_equal @link, view.link
    assert_present view.ip
    assert_present view.user_agent
  end

  test "accessing short URL increments views counter" do
    initial_count = @link.views_count

    get view_path(@link)

    @link.reload
    assert_equal initial_count + 1, @link.views_count
  end

  test "multiple accesses create multiple view records" do
    # First access
    assert_difference "View.count", 1 do
      get view_path(@link)
    end

    # Second access
    assert_difference "View.count", 1 do
      get view_path(@link)
    end

    # Should have 2 view records for this link
    assert_equal 2, @link.views.count
  end

  test "short URL works without authentication" do
    # Ensure no user is signed in
    get view_path(@link)

    # Should still redirect (public access)
    assert_response :redirect
    assert_redirected_to @link.url
  end

  test "invalid short URL returns 404" do
    get view_path("nonexistent")

    assert_response :not_found
  end
end
