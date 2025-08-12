require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "should require url" do
    link = Link.new(user: users(:one))
    assert_not link.valid?
  end

  test "should require a valid url format" do
    link = Link.new(
      user: users(:one),
      url: "invalid_url"
    )
    assert_not link.valid?
  end

  test "should be valid with valid attributes" do
    link = Link.new(
      user: users(:one),
      url: "https://valid_url.com"
    )
    assert link.valid?
  end

  test "should strip url whitespace" do
    link = Link.create(
      user: users(:one),
      url: "  https://valid_url.com  "
    )
    assert_equal "https://valid_url.com", link.url
  end

  test "should get domain" do
    link = Link.create(
      user: users(:one),
      url: "https://valid_url.com"
    )
    assert_equal "valid_url.com", link.domain
  end

  test "should encode id to base62" do
    link = links(:one)
    assert_equal link.to_param, Base62.encode(link.id)
  end

  test "should has_metadata? be true if at least title is present" do
    link = Link.create(
      user: users(:one),
      url: "https://valid_url.com",
      title: "Valid URL"
    )
    assert link.has_metadata?
  end

  test "should has_metadata? be true if description is present without title" do
    link = Link.create(
      user: users(:one),
      url: "https://valid_url.com",
      description: "Description"
    )
    assert link.has_metadata?
  end

  test "should has_metadata? be true if image is present without title or description" do
    link = Link.create(
      user: users(:one),
      url: "https://valid_url.com",
      image: "https://valid_url.com/image.jpg"
    )
    assert link.has_metadata?
  end

  test "should has_metadata? be false if no metadata fields are present" do
    link = Link.create(
      user: users(:one),
      url: "https://valid_url.com"
    )
    assert_not link.has_metadata?
  end
end
