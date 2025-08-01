require "test_helper"

class MetadataTest < ActiveSupport::TestCase
  test "title attribute" do
    assert_equal "Page title", Metadata.new("<title>Page title</title>").title
  end

  test "missing title attribute" do
    assert_nil Metadata.new.title
  end

  test "meta description attribute" do
    assert_equal "Page description", Metadata.new("<meta name='description' content='Page description'>").description
  end

  test "missing meta description attribute" do
    assert_nil Metadata.new.description
  end

  test "meta og:image attribute" do
    assert_equal "image.jpeg", Metadata.new("<meta property='og:image' content='image.jpeg'>").image
  end

  test "missing meta og:image attribute" do
    assert_nil Metadata.new.image
  end
end
