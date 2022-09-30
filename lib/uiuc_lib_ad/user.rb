module UiucLibAd
  class User
    attr_reader :dn, :ldap

    def initialize(ldap: nil, cn: nil, dn: nil)
      @config = UiucLibAd::Configuration.instance

      @ldap = ldap.nil? ? UiucLibAd::ActiveDirectory.new : ldap_conn

      # this module is meant to be used just by the library, so hence some hardcoding
      @user_treebase = @config.user_treebase.nil? ? "OU=People,Dc=ad,DC=uillinois,DC=edu" : @config.user_treebase
      @group_treebase = @config.group_treebase.nil? ? "OU=Library,OU=Urbana,DC=ad,DC=uillinois,DC=edu" : @config.group_treebase

      if dn.nil? && cn.nil?
        fail NoCNorDNException.new
      # probably shoudl warn here if given boht
      elsif !dn.nil? && !@ldap.dn_exists?(dn: dn)
        @dn = nil
      elsif !dn.nil?
        @dn = dn
      else
        begin
          @dn = @ldap.get_dn(cn: cn,
            treebase: @user_treebase,
            additional_filters: [Net::LDAP::Filter.eq("ObjectClass", "user")])
        rescue UiucLibAd::NoDNFound
          @dn = nil
        end
      end
    end

    def is_member_of?(group_cn: nil, group_dn: nil)
      # if user has no distinguish naem, they cannot
      # be part of a group
      if @dn.nil?
        return false
      end

      if group_dn.nil? && group_cn.nil?
        fail NoCNorDNException.new

      elsif !group_dn.nil? && !@ldap.dn_exists?(dn: group_dn)
        return false

      elsif !group_dn.nil?
        target_dn = group_dn

      else
        begin
          target_dn = @ldap.get_dn(cn: group_cn,
            treebase: @group_treebase,
            additional_filters: [Net::LDAP::Filter.eq("ObjectClass", "group")])
        rescue UiucLibAd::NoDNFound
          return false
        end
      end

      # filter = Net::LDAP::Filter.parse_ldap_filter("(memberOf:1.2.840.113556.1.4.1941:=#{target_dn})")

      # So, we want to base of the search to actually be the
      # dn of this entity a nd see if there's any chain "ismemberof"
      # with the targt_dn
      @ldap.dn_exists?(dn: @dn, filter: "(memberOf:1.2.840.113556.1.4.1941:=#{target_dn})")
    end
  end
end
