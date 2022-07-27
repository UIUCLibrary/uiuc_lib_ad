# frozen_string_literal: true

require "test_helper"

class UiucLibAdTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::UiucLibAd.const_defined?(:VERSION)
    end
  end

  # TODO: Look into mocking
  # following seems promising...
  # https://spin.atomicobject.com/2010/12/16/system-test-active-directory-authentication-in-ruby/

  # test "" do
  #
  #    assert_equal("expected", "actual")
  #  end
end
