require 'manageiq/network_discovery/port_scanner'

# Ports:
#        5900 - Microsoft Virtual Machine Remote Control Client

module ManageIQ
  module NetworkDiscovery
    class MSScvmmProbe
      def self.probe(ost)
        ost.hypervisor << :scvmm if PortScanner.scanPortArray(ost, [135, 139, 8100]).length == 3
      end
    end
  end
end
