{ ... }:
{
  adachi.hardware._.ugreen-led-controller.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      ugreenProbeLeds = pkgs.writeShellApplication {
        name = "ugreen-probe-leds";
        meta.platforms = pkgs.lib.platforms.linux;
        runtimeInputs = with pkgs; [
          i2c-tools
          kmod
        ];
        excludeShellChecks = [ "SC2181" ];
        text = ''
          # Load i2c-dev module
          { lsmod | grep i2c_dev ; } || modprobe -v i2c-dev

          # Load led-ugreen module
          if ! lsmod | grep -q led_ugreen; then
              if modprobe -v led-ugreen 2>/dev/null; then
                  echo "led-ugreen module loaded successfully"
              else
                  # modprobe failed — attempt DKMS build as fallback
                  echo "led-ugreen module not found, attempting DKMS build..."
                  KERNEL_VERSION=$(uname -r)
                  DKMS_VERSION=$(dkms status led-ugreen 2>/dev/null | grep -oP 'led-ugreen/\K[^,]+' | head -n1 || true)

                  if [ -n "$DKMS_VERSION" ]; then
                      echo "Building led-ugreen/''${DKMS_VERSION} for kernel ''${KERNEL_VERSION}..."
                      dkms install "led-ugreen/''${DKMS_VERSION}" -k "''${KERNEL_VERSION}" || {
                          echo "ERROR: Failed to build DKMS module for current kernel"
                          echo "Please install kernel headers: apt install linux-headers-''${KERNEL_VERSION}"
                          exit 1
                      }
                      echo "DKMS module built successfully"
                      modprobe -v led-ugreen
                  else
                      echo "ERROR: led-ugreen module could not be loaded"
                      echo "Install via DKMS: dkms install led-ugreen"
                      echo "Or load manually: insmod /path/to/led-ugreen.ko"
                      exit 1
                  fi
              fi
          fi

          i2c_dev=$(i2cdetect -l | grep "SMBus I801 adapter" | grep -Po "i2c-\d+")

          if [ $? = 0 ]; then 
                  echo "Found I2C device /dev/''${i2c_dev}"
                  dev_path=/sys/bus/i2c/devices/$i2c_dev/''${i2c_dev/i2c-/}-003a
                  if [ ! -d "$dev_path" ]; then
                      echo "led-ugreen 0x3a" > "/sys/bus/i2c/devices/''${i2c_dev}/new_device"
                  elif [ "$(cat "$dev_path/name")" != "led-ugreen" ]; then
                      echo "ERROR: the device ''${i2c_dev/i2c-/}-003a has been registered as $(cat "$dev_path/name")"
                      exit 1
                  fi
          else
                  echo "I2C device not found!"
          fi
        '';
      };
    in
    {
      boot.extraModulePackages = [
        (config.boot.kernelPackages.callPackage (
          {
            stdenv,
            fetchFromGitHub,
            kernel,
          }:
          stdenv.mkDerivation {
            pname = "led-ugreen";
            version = "unstable";

            src = fetchFromGitHub {
              owner = "miskcoo";
              repo = "ugreen_leds_controller";
              rev = "d6c3b3d7c74a68851e6cf71433aa9a7c313cda22";
              hash = "sha256-gNEjk2wN9GmeWtVQnVDvWtYxjmbKe3N0tTbwoIy3MYk=";
            };

            sourceRoot = "source/kmod";

            nativeBuildInputs = kernel.moduleBuildDependencies;

            makeFlags = [
              "KERNELRELEASE=${kernel.modDirVersion}"
              "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
              "INSTALL_MOD_PATH=$(out)"
            ];
          }
        ) { })
      ];

      boot.kernelModules = [
        "led-ugreen"
        "i2c-dev"
      ];

      systemd.services.ugreen-probe-leds = {
        enable = lib.mkDefault true;
        description = "UGREEN LED probe";
        script = lib.getExe ugreenProbeLeds;
        wantedBy = [ "sysinit.target" ];
      };
    };
}
