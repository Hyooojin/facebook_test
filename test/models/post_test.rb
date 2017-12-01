require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "post save" do
    post = Post.new({
      title: '포스트 테스트',
      content: '잘 되나?',
      user_id: 1

    })
    assert post.save, 'Failed to save'
    assert true
  end
end
