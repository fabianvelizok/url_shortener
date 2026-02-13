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
      get view_path(@link), headers: { "HTTP_USER_AGENT" => "Test Browser" }
    end

    # Check the view was recorded with correct data
    view = View.last
    assert_equal @link, view.link
    assert_not_nil view.ip
    assert_not_nil view.user_agent
  end

  test "accessing short URL increments views counter" do
    initial_count = @link.views_count

    get view_path(@link)

    @link.reload
    assert_equal initial_count + 1, @link.views_count
  end

  test "multiple accesses create multiple view records" do
    sign_in(@user)
    post links_path, params: { link: { url: "https://test-multiple-views.com" } }
    new_link = Link.last
    sign_out(@user)

    # First access
    assert_difference "View.count", 1 do
      get view_path(new_link)
    end

    # Second access
    assert_difference "View.count", 1 do
      get view_path(new_link)
    end

    # Should have exactly 2 view records for this new link
    assert_equal 2, new_link.views.count
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

  test "accessing short URL captures referrer" do
    get view_path(@link), headers: { "HTTP_REFERER" => "https://example.com/page" }

    view = View.last
    assert_equal "https://example.com/page", view.referrer
  end

  test "accessing short URL without referrer stores nil" do
    get view_path(@link)

    view = View.last
    assert_nil view.referrer
  end

  test "first view from unique IP increments unique_views_count" do
    link = create_link("https://test-unique.com")

    assert_equal 0, link.unique_views_count

    get view_path(link)
    link.reload
    assert_equal 1, link.unique_views_count

    # Same IP again — should not increment
    get view_path(link)
    link.reload
    assert_equal 1, link.unique_views_count
  end

  private

  def create_link(url)
    sign_in(@user)
    post links_path, params: { link: { url: url } }
    sign_out(@user)
    Link.last
  end
end
