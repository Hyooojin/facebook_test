require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user email validation (right)" do
    user = User.new({
      email: "asdf@qwer.com",
      password: "123123",
      password_confirmation: "123123"
    })
    assert user.save, 'Validation success' # assert_not
  end

  test "user email validation (wrong)" do
    user = User.new({
      email: "asdf",
      password: "123123",
      password_confirmation: "123123"
    })
    refute user.save, 'Validation success' # assert_not
  end

end
