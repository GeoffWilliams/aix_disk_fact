# test custom fact at lib/facter/user_audit.rb
require 'spec_helper'
require 'facter/ruby.rb'
require 'facter'

describe PuppetX::AixDiskFact::Disks do

  context "linux" do
    before do
      Facter.fact(:kernel).stubs(:value).returns("Linux")
      Facter.fact(:osfamily).stubs(:value).returns("RedHat")
    end
    it "does not activate on linux" do
      expect(Facter.value(:PE_18946)).to eq false
    end
  end

  context "solaris" do
    before do
      Facter.fact(:kernel).stubs(:value).returns("SunOS")
      Facter.fact(:osfamily).stubs(:value).returns("Solaris")
    end
    it "does not activate on solaris" do
      expect(Facter.value(:PE_18946)).to eq false
    end
  end

  context "aix" do
    before do
      Facter.fact(:kernel).stubs(:value).returns("AIX")
      Facter.fact(:osfamily).stubs(:value).returns("AIX")
    end
    it "activates on AIX" do
      expect(Facter.value(:PE_18946)).to eq "WARNING: you have loaded a workaround for PE-18946"
    end
  end

end
