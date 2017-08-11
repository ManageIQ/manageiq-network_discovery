require 'ostruct'
require 'util/miq-ipmi'

describe ManageIQ::NetworkDiscovery::DiscoverProbe do
  context ".getProductMod" do
    let(:ost) { OpenStruct.new(:discover_types => [:ipmi], :ipaddr => "127.0.0.1", :hypervisor => []) }
    it "hypervisor is ipmi when available" do
      allow(MiqIPMI).to receive(:is_available?).and_return(true)
      described_class.getProductMod(ost)

      expect(ost.hypervisor).to eql([:ipmi])
    end

    it "no hypervisor if ipmi isn't available" do
      allow(MiqIPMI).to receive(:is_available?).and_return(false)
      described_class.getProductMod(ost)

      expect(ost.hypervisor).to eql([])
    end
  end
end
