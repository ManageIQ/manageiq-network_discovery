require "spec_helper"

RSpec.describe Manageiq::NetworkDiscovery do
  it "has a version number" do
    expect(Manageiq::NetworkDiscovery::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
