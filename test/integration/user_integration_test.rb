require "test_helper"

class UserIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "user can sign in and see their email in navbar" do
    get new_user_session_path
    assert_response :success

    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password"
      }
    }

    assert_redirected_to root_path
    follow_redirect!
    
    # Check that user email appears in navbar
    assert_select "nav span", text: @user.email
    assert_select "nav", text: /Sign out/
  end

  test "user can sign out and see sign in link" do
    sign_in(@user)
    
    # Verify user is signed in
    get root_path
    assert_response :success
    assert_select "nav span", text: @user.email

    # Sign out using the button
    delete destroy_user_session_path
    assert_redirected_to root_path
    follow_redirect!

    # Should now see sign in link instead of email
    assert_select "nav a", text: "Sign in"
    assert_select "nav span", text: @user.email, count: 0
  end

  test "unauthenticated user sees sign in link in navbar" do
    get root_path
    
    # Should be redirected to sign in
    assert_redirected_to new_user_session_path
    follow_redirect!
    
    # Should see sign in link in navbar
    assert_select "nav a", text: "Sign in"
    assert_select "nav span", count: 0  # No email shown
  end

  test "user cannot sign in with invalid credentials" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "wrong_password"
      }
    }

    assert_response :unprocessable_entity
    # Should still be on sign in page, no email in navbar
    assert_select "nav a", text: "Sign in"
    assert_select "nav span", text: @user.email, count: 0
  end
end
