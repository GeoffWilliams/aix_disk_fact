require 'puppetx/aix_disk_fact'
# tell user fact is active on AIX
Facter.add(:FACT_1552) do
  confine :kernel => 'AIX'
  has_weight 100
  setcode do
    'WARNING: you have loaded a workaround for FACT-1552'
  end
end

# tell user fact is present on all other platforms
Facter.add(:FACT_1552) do
  setcode do
    false
  end
end

# Thanks Zack!
# http://wallcity.org/blog/2013/01/21/confine-a-dynamic-fact-using-another-fact/
if Facter.value(:kernel) == 'AIX'
  Facter.add(:disks) do
    confine :kernel => 'AIX'
    setcode do
      PuppetX::AixDiskFact::Disks.run_fact()
    end
  end

  Facter.add(:mountpoints) do
    confine :kernel => 'AIX'
    setcode do
      PuppetX::AixDiskFact::MountPoints.run_fact()
    end
  end
end
