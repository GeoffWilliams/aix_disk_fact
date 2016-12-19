require 'puppetx/aix_disk_fact'
# tell user fact is active on AIX
Facter.add(:PE_18946) do
  confine :kernel => 'AIX'
  has_weight 100
  setcode do
    'WARNING: you have loaded a workaround for PE-18946'
  end
end

# tell user fact is present on all other platforms
Facter.add(:PE_18946) do
  setcode do
    false
  end
end

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
