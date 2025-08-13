require "test_helper"

class LinkIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @link = links(:one)
  end

  test "unauthenticated user can not see dashboard" do
    get "/"
    assert_redirected_to new_user_session_path
  end

  test "authenticated user can see dashboard" do
    sign_in(@user)
    get "/"
    assert_response :success
  end

  test "user can create a short link in html format" do
    sign_in(@user)
    get "/"
    assert_response :success

    assert_difference "Link.count" do
      post links_path, params: {
        link: { url: "https://valid-url.com" }
      }
    end
    assert_response :redirect
    follow_redirect!
    assert_equal "Link was successfully created.", flash[:notice]
  end

  test "user can create a short link in turbo_stream format" do
    sign_in(@user)
    get "/"
    assert_response :success

    assert_difference "Link.count" do
      post links_path(format: :turbo_stream), params: {
        link: { url: "https://valid-url.com" }
      }
    end
    assert_response :success
  end

  test "user is redirected to url and views are incremented" do
    sign_in(@user)
    get "/"
    assert_response :success

    assert_difference "Link.count" do
      post links_path(format: :turbo_stream), params: {
        link: { url: "https://valid-url.com" }
      }
    end
    assert_response :success

    @link = Link.last
    # Sign out to see public access
    sign_out(@user)

    # Check views
    initial_count = @link.views_count
    assert_difference "View.count" do
      get view_path(@link)
    end
    @link.reload
    assert_equal initial_count + 1, @link.views_count

    # Redirect to correct url
    assert_redirected_to @link.url
  end

  test "user can see their own links" do
    sign_in(@user)
    get links_path
    assert_response :success
    assert_select ".link-item", @user.links.count
  end

  test "user can edit its own link" do
    sign_in(@user)
    get edit_link_path(@link)
    assert_response :success

    patch link_path(@link), params: {
      link: { url: "https://updated-url.com" }
    }
    assert_redirected_to @link

    follow_redirect!
    assert_response :success
    assert_match "Link was successfully updated", response.body

    @link.reload
    assert_equal "https://updated-url.com", @link.url
  end

  test "user can delete its own link" do
    sign_in(@user)
    assert_difference "Link.count", -1 do
      delete link_path(@link)
    end
    assert_redirected_to root_path
    assert_equal "Link was successfully deleted.", flash[:notice]
  end

  test "user cannot access another user's link edit page" do
    other_user = users(:two)
    other_link = links(:two)

    sign_in(@user)

    get edit_link_path(other_link)
    assert_response :not_found
  end

  test "invalid URL submission shows error" do
    sign_in(@user)

    assert_no_difference "Link.count" do
      post links_path, params: { link: { url: "invalid-url" } }
    end

    assert_response :unprocessable_entity
    assert_match "is invalid", response.body
  end

  test "invalid short URL returns 404" do
    get view_path("nonexistent")
    assert_response :not_found
  end
end
