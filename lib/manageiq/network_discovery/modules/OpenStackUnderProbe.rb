require 'manageiq/network_discovery/port_scanner'

module ManageIQ
  module NetworkDiscovery
    class OpenStackUnderProbe
      def self.probe(ost)
        log_header = "OpenStackUnderProbe"
        unless ost.discover_types.include?(:openstack_undercloud)
          $log.debug "Skipping #{log_header}" if $log
          return
        end

        $log.debug "#{log_header}: probing ip = #{ost.ipaddr}" if $log

        res = ""
        if PortScanner.portOpen(ost, 6385)
          Socket.tcp(ost.ipaddr, 6385) {|s|
            s.print("GET / HTTP/1.0")
            s.close_write
            res = s.read
          }
        end
        ost.hypervisor << :openstack_undercloud if res =~ /OpenStack Ironic API/
        $log.debug "#{log_header}: probe of ip = #{ost.ipaddr} complete" if $log
      end
    end
  end
end
