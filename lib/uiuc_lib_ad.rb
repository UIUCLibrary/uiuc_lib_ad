# frozen_string_literal: true

require_relative "uiuc_lib_ad/configuration"
require_relative "uiuc_lib_ad/version"
require_relative "uiuc_lib_ad/user"
require_relative "uiuc_lib_ad/active_directory"

module UiucLibAd
  class NoDNFound < StandardError; end

  class MultipleDNsFound < StandardError; end
end
