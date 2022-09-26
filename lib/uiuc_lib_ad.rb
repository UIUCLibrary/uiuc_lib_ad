# frozen_string_literal: true

require_relative "uiuc_lib_ad/configuration"
require_relative "uiuc_lib_ad/version"

module UiucLibAd
  class Error < StandardError; end
  # Your code goes here...

  require "net-ldap"
  require "yaml"

  class NoCNorDNException < StandardError
    def initialize(msg = "At least one of entity_cn or entity_dn must be set. if both are set, entity_dn will be used")
      super(msg)
    end
  end

  class NoDNFound < StandardError; end

  class Entity
    attr_reader :dn, :ldap

    def self.default_ldap
      config = UiucLibAd::Configuration.instance
      ldap = Net::LDAP.new host: config.server,
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

      ldap.bind

      ldap
    end

    def initialize(ldap: nil, entity_cn: nil, entity_dn: nil)
      @ldap = if ldap.nil?
        Entity.default_ldap
      else
        ldap_conn
      end

      @dns = get_dns(cn: entity_cn, dn: entity_dn)
    end

    def get_dns(cn: nil, dn: nil)
      if dn.nil? && cn.nil?
        fail NoCNorDNException.new
      elsif !dn.nil?
        return [dn]
      end

      attrs = ["dn"]

      filter = Net::LDAP::Filter.eq("cn", cn)
      dns = []

      @ldap.search(base: UiucLibAd::Configuration.instance.treebase,
        filter: filter,
        attributes: attrs) do |entry|
        dns << entry.dn
      end

      if dns.empty?
        fail NoDNFound.new
      end

      # return the dns
      dns
    end

    def is_member_of?(group_cn: nil, group_dn: nil)
      attrs = ["cn"]

      # probably could refactor witht he initializer logic, or move some of that into the
      # get dn call

      target_dns = get_dns(cn: group_cn, dn: group_dn)
      target_dns.each do |target_dn|
        filter = "(memberOf:1.2.840.113556.1.4.1941:=#{target_dn})"
        dns = []
        @dns.each do |dn|
          # So, we want to base of the search to actually be the
          # dn of this entity a nd see if there's any chain "ismemberof"
          # witht he targt_dn
          @ldap.search(base: dn,
            filter: filter,
            attributes: attrs) do |entry|
            dns << entry.dn
          end

          if dns.any?
            return true
          end
        end
      end
      false
    end
  end
end
