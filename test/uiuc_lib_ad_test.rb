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
    user = UiucLibAd::User.new(cn: "jtgorman")

    assert(user.is_member_of?(group_cn: "Library IT - IMS Faculty and Staff"))
  end

  # THIS TEST COULD BREAK - not mocked
  test "jtgorman is not a member of Library IT - WNS Faculty and Staff" do
    user = UiucLibAd::User.new(cn: "jtgorman")

    assert(!user.is_member_of?(group_cn: "Library IT - WNS Faculty and Staff"))
  end

  test "using dn when creating user" do
    user = UiucLibAd::User.new(dn: "CN=jtgorman,OU=People,DC=ad,DC=uillinois,DC=edu")

    assert(user.is_member_of?(group_cn: "Library IT - IMS Faculty and Staff"))
  end


  test "using dn when checking group" do
    user = UiucLibAd::User.new(dn: "CN=jtgorman,OU=People,DC=ad,DC=uillinois,DC=edu")

    assert(user.is_member_of?(group_dn: " CN=Library IT - IMS Faculty and Staff,OU=IT - IMS,OU=Units,OU=Library,OU=Urbana,DC=ad,DC=uillinois,DC=edu"))
  end

  test "user that same cn as other object" do
    user = UiucLibAd::User.new(cn: "braxton")

    assert(user.is_member_of?(group_cn: "Library - all users"))
  end



end
