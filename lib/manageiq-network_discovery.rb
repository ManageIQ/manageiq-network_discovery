module ManageIQ
  module NetworkDiscovery
    autoload :IpmiProbe, 'manageiq/network_discovery/modules/IpmiProbe'
    autoload :MSScvmmProbe, 'manageiq/network_discovery/modules/MSScvmmProbe'
    autoload :MSVirtualServerProbe, 'manageiq/network_discovery/modules/MSVirtualServerProbe'
    autoload :RedHatRhevmProbe, 'manageiq/network_discovery/modules/RedHatRhevmProbe'
    autoload :VMwareEsxVcProbe, 'manageiq/network_discovery/modules/VMwareEsxVcProbe'
    autoload :VMwareServerProbe, 'manageiq/network_discovery/modules/VMwareServerProbe'
    autoload :WindowsProbe, 'manageiq/network_discovery/modules/WindowsProbe'
  end

  module Providers
    module Openstack
      autoload :InfraDiscovery, 'manageiq/providers/openstack/infra_discovery'
    end
  end
end

require "manageiq/network_discovery.rb"
