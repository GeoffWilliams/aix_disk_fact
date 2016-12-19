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
          size_b = size_m * 1024 * 1024
          size_g = size_m / 1024.0

          data[device] = {
            'size'        => "#{format("%.2f", size_g)} GiB",
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
      FREE      = 2
      USED_PC   = 3
      MOUNTED   = 4

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
          "df #{mount} | awk 'NR>1 {print $1, $2, $3, $4, $7}'"
        ).strip.split(/\s/)
      end

      def self.mount_type(mount)
        Facter::Core::Execution.exec(
          "lsfs #{mount} | awk 'NR>1 {print $4}'"
        )
      end

      def self.run_fact()
        data = {}
        vol_groups().each{ |vol_group|
          mounts(vol_group).each { |mount|
            mount_info  = mount_info(mount)
            free_b      = mount_info[FREE].to_i * 512
            free_g      = free_b /1024.0/1024.0/1024.0
            size_b      = mount_info[SIZE].to_i * 512
            size_g      = size_b /1024.0/1024.0/1024.0
            used_b      = size_b - free_b
            used_g      = used_b /1024.0/1024.0/1024.0
            capacity    = (used_b /size_b) * 100

            data[mount] = {
              'available'       => "#{format("%.2f", free_g)} GiB",
              'available_bytes' => free_b,
              'capacity'        => "#{format("%.2f", capacity)}%",
              'device'          => mount_info[DEVICE],
              'filesystem'      => mount_type(mount),
              'options'         => [
                "NA",
              ],
              'size'            => "#{format("%.2f", size_g)} GiB",
              'size_bytes'      => size_b,
              'used'            => "#{format("%.2f", used_g)} GiB",
              'used_bytes'      => used_b
            }
          }
        }
        data
      end
    end
  end
end
