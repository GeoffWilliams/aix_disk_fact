module PuppetX
  module AixDiskFact
    # Regular facter on linux outputs disks like this
    # disks => {
    #   vda => {
    #     size => "48.83 GiB",
    #     size_bytes => 52428800000,
    #     vendor => "0x1af4"
    #   }
    # }
    module Disks

      # list of the disks
      def self.disks()
        raw_cmd = Facter::Core::Execution.exec(
          "lspv | awk '$4 == \"active\" {print $1}'"
        )
        if raw_cmd
          v = raw_cmd.split(/\s+/)
        else
          v = []
        end
        v
      end

      def self.disk_space(device)
        Facter::Core::Execution.exec(
          "getconf DISK_SIZE /dev/#{device}"
        )
      end

      def self.run_fact()
        data = {}
        disks().each { |device|
          size_m = disk_space(device).to_i
          size_b = size_m.to_i * 1024 * 1024
          size_h = "#{size_m.to_i/1024} GiB"
          data[device] = {
            'size'        => size_h,
            'size_bytes'  => size_b,
            'vendor'      => 'NA',
          }
        }
        data
      end
    end

    # Regular facter on linux outputs mountpoints like this
    # /sys/fs/cgroup => {
    #   available => "2.49 GiB",
    #   available_bytes => 2669690880,
    #   capacity => "94.63%",
    #   device => "/dev/vda1",
    #   filesystem => "ext4",
    #   options => [
    #     "rw",
    #     "relatime",
    #     "data=ordered"
    #   ],
    #   size => "46.26 GiB",
    #   size_bytes => 49671180288,
    #   used => "43.77 GiB",
    #   used_bytes => 47001489408
    #  }
    # }
    module MountPoints
      DEVICE    = 0
      SIZE      = 1
      USED      = 2

      def self.vol_groups()
        raw_cmd = Facter::Core::Execution.exec(
          "lsvg"
        )
        if raw_cmd
          v = raw_cmd.split(/\s+/)
        else
          v = []
        end
        v
      end

      def self.mounts(vol_group)
        raw_cmd = Facter::Core::Execution.exec(
          "lsvgfs #{vol_group}"
        )
        if raw_cmd
          f = raw_cmd.split(/\s+/)
        else
          f = []
        end
        f
      end

      def self.mount_info(mount)
        Facter::Core::Execution.exec(
          "df -g #{mount} | awk 'NR>1 {print $7,$1,$2}'"
        ).strip.split(/\s/)
      end

      def self.run_fact()
        data = {}
        vol_groups().each{ |vol_group|
          mounts(vol_group).each { |mount|
            mount_info = mount_info(mount)
            data[mount] = {
              'available'       => "NA",
              'available_bytes' => -1,
              'capacity'        => "NA",
              'device'          => mount_info[DEVICE],
              'filesystem'      => "NA",
              'options'         => [
                "NA",
              ],
              'size'            => "NA",
              'size_bytes'      => mount_info[SIZE],
              'used'            => "NA",
              'used_bytes'      => mount_info[USED]
            }
          }
        }
        data
      end
    end
  end
end
