require 'manageiq/network_discovery/port_scanner'

# Ports:
#        135  - Microsoft Remote Procedure Call (RPC)
#        139  - NetBIOS Session (TCP), Windows File and Printer Sharing
#        445  - SMB (Server Message Block) over TCP/IP
#        3389 - RDP

module ManageIQ
  module NetworkDiscovery
    class WindowsProbe
      def self.probe(ost)
        ost.os << :mswin  if PortScanner.scanPortArray(ost, [135, 139]).length == 2
      end
    end
  end
end
