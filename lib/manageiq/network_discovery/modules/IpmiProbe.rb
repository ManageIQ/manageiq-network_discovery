require 'util/miq-ipmi'

module ManageIQ
  module NetworkDiscovery
    class IpmiProbe
      def self.probe(ost)
        ost.hypervisor << :ipmi if MiqIPMI.is_available?(ost.ipaddr)
      end
    end
  end
end
