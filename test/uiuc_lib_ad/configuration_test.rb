# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Test::Unit::TestCase
  setup do
    @config = ::UiucLibAd::Configuration.new(key1: "value1", key2: "value2")
  end

  test "instance() returns the global instance" do
    assert_not_nil UiucLibAd::Configuration.instance
  end

  test "instance=() sets the global instance" do
    UiucLibAd::Configuration.instance = UiucLibAd::Configuration.new(
      key1: "new_value"
    )
    assert_equal "new_value", UiucLibAd::Configuration.instance.key1
  end

  test "initialize() sets ivars correctly" do
    assert_equal "value1", @config.key1
    assert_equal "value2", @config.key2
  end

  test "method_missing() returns an ivar value for an existing ivar" do
    assert_equal "value1", @config.key1
  end

  test "method_missing() falls back to the environment for a missing ivar" do
    ENV["UIUCLIBAD_TEST"] = "test_value"
    assert_equal "test_value", @config.test
  end

  test "method_missing() returns nil for a value not present as either an ivar or in the environment" do
    assert_nil @config.bogus_key
  end
end
