require "manageiq/network_discovery/version"
require "manageiq/network_discovery/port_scanner"

#######################################################################
#
# Taken from http://www.cs.cornell.edu/skeshav/papers/discovery.pdf
#
#######################################################################

module ManageIQ
  module NetworkDiscovery
	  #######################################################################
	  #
	  # SNMP Discovery
	  #   1. temporarySet = get_default_router()
	  #   2. foreach router in temporarySet do
	  #     a. ping(this_router)
	  #     b. if (this_router is alive) then add this_router to permanentSet
	  #     c. hostList = SNMP_GetArpTable(this_router)
	  #     d. add hostList to permanentSet
	  #     e. routerList = SNMP_GetIpRouteTable(this_router)
	  #     f. add routerList to permanentSet
	  #     f. add routerList to temporarySet
	  #
	  #######################################################################

	  #######################################################################
	  #
	  # DNS Zone Transfer with Traceroute
	  #   1. temporarySet = DNS_domain_transfer(domain)
	  #   2. initialize cumulativeAnds and cumulativeOrs hashtables to null
	  #   3. foreach node in temporarySet do
	  #     a. ping(this_node)
	  #     b. if (this_node is alive) then add this_node to permanentSet else continue
	  #     c. traceroute(node)
	  #     d. this_router = penultimate hop in traceroute
	  #     e. find all IP addresses of this_router with a DNS lookup
	  #     f. this_gateway = address such that number of '1' bits in IP(this_router) XOR this_node is minimized
	  #     g. oldSubnet = cumulativeAnds[this_gateway]
	  #     h. cumulativeAnds[this_gateway] = this_node AND cumulativeAnds[this_gateway]
	  #     i. cumulativeOrs[this_gateway] = this_node OR cumulativeOrs[this_gateway]
	  #     j. newSubnet = cumulativeAnds[this_gateway]
	  #     k. newSubnetMask = NOT (cumulativeAnds[this_gateway] XOR cumulativeOrs[this_gateway])
	  #     l. store node in newSubnet
	  #     m. if necessary, move hosts in permanent set's oldSubnet to newSubnet
	  #
	  #######################################################################

	  #######################################################################
	  #
	  # Probing with Traceroute
	  #   1. temporarySet = random addresses in domain that end in ".1"
	  #   2. initialize cumulativeAnds and cumulativeOrs hashtables to null
	  #   3. foreach node in temporarySet do
	  #     a. ping(this_node)
	  #     b. if (this_node is alive) then add this_node to permanentSet else continue
	  #     c. use Heuristic3 to add more addresses to temporarySet
	  #     d. traceroute(node)
	  #     e. this_router = penultimate hop in traceroute
	  #     f. find all IP addresses of this_router with a DNS lookup
	  #     g. this_gateway = address such that number of '1' bits in IP(this_router) XOR this_node is minimized
	  #     h. oldSubnet = cumulativeAnds[this_gateway]
	  #     i. cumulativeAnds[this_gateway] = this_node AND cumulativeAnds[this_gateway]
	  #     j. cumulativeOrs[this_gateway] = this_node OR cumulativeOrs[this_gateway]
	  #     k. newSubnet = cumulativeAnds[this_gateway]
	  #     l. newSubnetMask = NOT (cumulativeAnds[this_gateway] XOR cumulativeOrs[this_gateway])
	  #     m. store node in newSubnet
	  #     n. if necessary, move hosts in permanent set's oldSubnet to newSubnet
	  #
	  #######################################################################

    PROVIDERS_BY_TYPE = {
      :openstack_infra => "ManageIQ::Providers::Openstack::InfraDiscovery",
      # Following to be moved to ManageIQ::Providers or MiqIPMI or equivalent or Host/Helper
      :ipmi            => "ManageIQ::NetworkDiscovery::IpmiProbe",
      :scvmm           => "ManageIQ::NetworkDiscovery::MSScvmmProbe",
      :msvirtualserver => "ManageIQ::NetworkDiscovery::MSVirtualServerProbe",
      :rhevm           => "ManageIQ::NetworkDiscovery::RedHatRhevmProbe",
      :virtualcenter   => "ManageIQ::NetworkDiscovery::VMwareEsxVcProbe",
      :esx             => "ManageIQ::NetworkDiscovery::VMwareServerProbe",
      :vmwareserver    => "ManageIQ::NetworkDiscovery::VMwareServerProbe",
      :mswin           => "ManageIQ::NetworkDiscovery::WindowsProbe"
    }

    def self.scanHost(sInfo)
      require 'net/ping'
      sInfo.os = []
      sInfo.hypervisor = []

      # If the usePing flag is set we try to ping the box first
      # and skip scanning if the ping fails.
      pingOk = true
      begin
        pingOk = Net::Ping::External.new(sInfo.ipaddr).ping if sInfo.usePing
      rescue Timeout::Error
        pingOk = false
      end

      if pingOk
        # Trigger probes
        sInfo.discover_types.each do |type|
          next unless PROVIDERS_BY_TYPE.include?(type)
          klass = Object.const_get(PROVIDERS_BY_TYPE[type])
          $log.info "#{klass}: probing ip = #{sInfo.ipaddr}" if $log
          klass.send(:probe, sInfo)
          $log.info "#{klass}: probe of ip = #{sInfo.ipaddr} complete" if $log
        end
      end
    end

    private

    def getDefaultRouter
    end

    # Given an IP address, determine the length of the address mask associated with that address
    #
    # for masklen = 31 to 7 do
    #   a. assume network mask is of length masklen
    #   b. construct the '0' and '255' directed broadcast addresses for that address and masklen
    #   c. ping these directed broadcast addresses
    #   d. if more than two hosts reply to both pings then return masaklen else continue
    def heuristic1
    end

    # A way to choose 32-bit values that, with good probability, lie within a choen subnet's address space
    #
    # foreach address successfully pinged
    #   add the next N consecutive addreses to temporarySet
    #   if (address ends in 1, 63, 129, or 193) // a router: may have other hosts in this space
    #     add N random addresses with the same prefix to temporarySet
    def heuristic3
    end
  end
end
