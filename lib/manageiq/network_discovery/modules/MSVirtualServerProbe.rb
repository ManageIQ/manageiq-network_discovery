require 'manageiq/network_discovery/port_scanner'

# Ports:
#        5900 - Microsoft Virtual Machine Remote Control Client

module ManageIQ
  module NetworkDiscovery
    class MSVirtualServerProbe
      def self.probe(ost)
        ost.hypervisor << :msvirtualserver if PortScanner.portOpen(ost, "5900")
      end
    end
  end
end
