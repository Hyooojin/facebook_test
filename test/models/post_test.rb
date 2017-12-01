require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "post save" do
    post = Post.new({
      title: '포스트 테스트',
      content: '잘 되나?',
      user_id: 1

    })
    assert post.save, 'Failed to save'
  end

  test "post " do
    post = Post.new({
      title: Faker::Lorem.paragraph(sentence_count = 100),
      content: Faker::Lorem.paragraph(sentence_count = 200),
      user_id: 1
    })
    refute post.save, 'Validation success' # assert_not
  end
end
