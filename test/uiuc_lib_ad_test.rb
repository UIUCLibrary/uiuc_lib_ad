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

  # THIS TEST COULD BREAK - not mocked
  test "jtgorman is member of Library IT - IMS Faculty and Staff" do
    require 'uiuc_lib_ad'

    user = UiucLibAd::Entity.new( entity_cn: "jtgorman" )
    
    assert(user.is_member_of?(group_cn: "Library IT - IMS Faculty and Staff"))

  end


   # THIS TEST COULD BREAK - not mocked
   test "jtgorman is not a member of Library IT - WNS Faculty and Staff" do
    user = UiucLibAd::Entity.new( entity_cn: "jtgorman" )
    
    assert(!user.is_member_of?(group_cn: "Library IT - WNS Faculty and Staff"))
   end
end
