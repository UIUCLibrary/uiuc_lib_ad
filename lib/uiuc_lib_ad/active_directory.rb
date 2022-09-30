module UiucLibAd
  class ActiveDirectory
    require "net-ldap"
    require "pry"

    def initialize
      config = UiucLibAd::Configuration.instance

      server = config.server.nil? ? "ad.uillinois.edu" : config.server

      @connection = Net::LDAP.new host: server,
        port: 389,
        auth: {
          method: :simple,
          username: config.user,
          password: config.password
        },
        encryption: {
          method: :start_tls,
          tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS
        }
      @connection.bind
    end

    # This searches for a full distingusish name from a cn (netid or group name)
    def get_dn(cn: nil, treebase: "DC=ad,DC=uillinois,DC=edu", additional_filters: [])
      attrs = ["dn"]

      filter = Net::LDAP::Filter.eq("cn", cn)

      additional_filters.each do |new_filter|
        filter &= new_filter
      end

      dns = []

      # binding.pry

      @connection.search(base: treebase,
        filter: filter,
        attributes: attrs) do |entry|
        dns << entry.dn
      end

      if dns.empty?
        fail NoDNFound.new
      elsif dns.length > 1
        fail MultipleDNsFound.new
      end

      # return the dns
      dns[0]
    end

    # This searches for a full distingusish name from a cn (netid or group name)
    def dn_exists?(dn: nil, filter: nil)
      @connection.search(base: dn,
        filter: filter) do |entry|
        return true
      end
      false
    end
  end
end
