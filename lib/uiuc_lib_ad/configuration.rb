module UiucLibAd
  class Configuration
    @@instance = Configuration.new

    def self.instance
      @@instance
    end

    def self.instance=(instance)
      @@instance = instance
    end

    def initialize(**args)
      args.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def method_missing(symbol, *args)
      instance_variable_get("@#{symbol}") || ENV["UIUCLIBAD_#{symbol.to_s.upcase}"]
    end

    def respond_to_missing? *args
      true
    end
  end
end
