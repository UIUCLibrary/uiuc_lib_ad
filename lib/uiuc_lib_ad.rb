# frozen_string_literal: true

require_relative "uiuc_lib_ad/version"
require 'pry'

module UiucLibAd
  class Error < StandardError; end
  # Your code goes here...

  require 'net-ldap'
  require 'yaml'

  


  class NoCNorDNException < StandardError 
    def initialize(msg="At least one of entity_cn or entity_dn must be set. if both are set, entity_dn will be used")
      super(msg)
    end
  end
 
  class MultiplePossibleDNs < StandardError 
    def initialize( returned_dns )
      @returned_dns = returned_dns
      super(message)
    end

    def message
      "Multiple DNS found: " + @returned_dns.join("\n")       
    end

  end

  class NoDNFound < StandardError ; end




  class Entity  
    attr_reader :dn, :ldap

    def self.default_ldap

      config = YAML::load_file( __dir__ + '/../config/config.yml' )
      
      ldap = Net::LDAP.new :host => config['adserver'],
                           :port => 389,
                           :auth => {
                            :method   => :simple,
                            :username => ENV['UIUCLIBAD_USER'],
                            :password => ENV['UIUCLIBAD_PASSWORD'],
                          },
                          :encryption => {
                            :method => :start_tls,
                            :tls_options => OpenSSL::SSL::SSLContext::DEFAULT_PARAMS,
                          }

       ldap.bind 
       
       ldap
    

    end

    def initialize(ldap: nil, entity_cn: nil, entity_dn: nil )
      @config = YAML::load_file( __dir__ + '/../config/config.yml' )

      if ldap.nil?
        @ldap = Entity.default_ldap
      else
        @ldap = ldap_conn 
      end
      

      @dn = get_dn(cn: entity_cn, dn: entity_dn)

      
    end

    def get_dn( cn: nil, dn: nil )

      if dn.nil? && cn.nil?
        fail NoCNorDNException.new 
      elsif !dn.nil?
        return dn
      end


      attrs    = ['dn']
       
      filter = Net::LDAP::Filter.eq("cn",cn)
      dns = [] 
       
      @ldap.search( :base       => @config['treebase'],
                   :filter     => filter,
                   :attributes => attrs
                 )  do | entry |
         
        dns << entry.dn
      end

      if dns.length > 1
        fail MultiplePossibleDNs.new( dns )
      elsif dns.length < 1
        fail NoDNFound.new()
      end
      
      # return the dn
      dns[0]
    end

    def is_member_of?( group_cn: nil, group_dn: nil )
     
      attrs    = ['cn']
      
      # probably could refactor witht he initializer logic, or move some of that into the 
      # get dn call

      target_dn = get_dn(cn: group_cn, dn: group_dn)

      filter = "(memberOf:1.2.840.113556.1.4.1941:=#{target_dn})"
      dns = [] 
       
      # So, we want to base of the search to actually be the
      # dn of this entity a nd see if there's any chain "ismemberof" 
      # witht he targt_dn
      @ldap.search(:base       => @dn,
                   :filter     => filter,
                   :attributes => attrs
                 )  do | entry |
         
        dns << entry.dn
      end


      if dns.length >= 1
        return true
      end
      
      # return the dn
      false

    end

  end
end
