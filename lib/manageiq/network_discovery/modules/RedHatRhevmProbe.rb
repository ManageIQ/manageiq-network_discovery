require 'manageiq/network_discovery/port_scanner'

module ManageIQ
  module NetworkDiscovery
    class RedHatRhevmProbe
      def self.probe(ost)
        require 'ovirt'
        Ovirt.logger = $rhevm_log if $rhevm_log

        if PortScanner.portOpen(ost, Ovirt::Service::DEFAULT_PORT)
          if Ovirt::Service.ovirt?(:server => ost.ipaddr, :verify_ssl => false)
            ost.hypervisor << :rhevm
          end
        end
      end
    end
  end
end
