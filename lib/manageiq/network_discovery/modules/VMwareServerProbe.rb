require 'manageiq/network_discovery/port_scanner'

# Ports:
#        902  - VMware Server console
#        912  - VMware Server console

module ManageIQ
  module NetworkDiscovery
    class VMwareServerProbe
      def self.probe(ost)
        ost.hypervisor << :vmwareserver if PortScanner.scanPortArray(ost, [902, 912]).length == 2
      end
    end
  end
end
