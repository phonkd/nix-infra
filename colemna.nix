{
  meta = {
  };

  defaults = { pkgs, ... }: {
    # This module will be imported by all hosts
    system.stateVersion = "24.05"; # Did you read the comment?
    environment.systemPackages = with pkgs; [
      vim wget curl git
    ];
    time.timeZone = "Europe/Zurich";
    console.keyMap = "sg";
    users.users.phonkd = {
      isNormalUser = true;
      description = "phonkd";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
    security.sudo.wheelNeedsPassword = false;
    nixpkgs.config.allowUnfree = true;
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.copySystemConfiguration = true;
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "no";
    };
    users.users."phonkd".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIEyBDdu7HwhZLnwBQaqpMohxhpzGbpw7xbYG15NXxst elis.steiner@bedag.ch"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbowr9v6+9oGVlUe5YNum0Z6uwEiJ+ep/7YHo8xCMnkuoemBe7Hr87uNhyIg0tEFJ261DgTVhi/0orn77Al2Hr1GNYBtnZAqEYGt0fEwYbAQZknDrCyWFe9LM+OIiWldbvtWpS6k7eRwqGMT2Mj3DyBI4g+RPTDJ2IEsBNGQOMCEtQwhtde2TIOC6HrX0b6cvxDyg20ApH5qPBsLT3n/9FIg5+Tzt5NDLraAgClzmAnMBwTylp1FI2q+Q9aWmZ+6FjBU8pltNthT6EMRApsI1wF7UhvVDztb/+7qnSng8iCrYctLeSJ3LBWj3zRustYbNpCTxvD2umbt5k8Qi9lHhbyEB/XjTx7/26hsOiJ4MSrYmGfYeQuOOamLASJP0VOp2/3VEnFwL8fAqQJ+xoI53us0LohOtItWB1ipcTbOpV/qgtDzPeiW/F4kSH/aV9l92HjptFjDnAfUOqcJk+UjmwxZjpLoIl4A6OtFs+cmqyDVqV3ljjKYEhWzOhdGKBwg0= phonkd@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcHae4fMVL9fhWtpWzeC78PwjH9pUqWLax4qfuxWmDi phonkd@staubiger"
    ];
  };

  host-a = { name, nodes, ... }: {
    # The name and nodes parameters are supported in Colmena,
    # allowing you to reference configurations in other nodes.
    networking.hostName = raspy;
    fileSystems."/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
    deployment.targetHost = "raspy.int.phonkd.net";
    networking = {
      interfaces.ens18 = {
        ipv4.addresses = [{
          address = "192.168.1.200";
          prefixLength = 24;
        }];
      };
      nameservers = [ "192.168.1.1" ];
      defaultGateway = {
        address = "192.168.1.1";
        interface = "ens18";
      };
    };
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
        grub.device = "/dev/sda";
      };
    };
    # -------------- Services ---------------- #
    services.uptime-kuma.enable = true;
  };

  # host-b = {
  #   # Like NixOps and morph, Colmena will attempt to connect to
  #   # the remote host using the attribute name by default. You
  #   # can override it like:
  #   deployment.targetHost = "host-b.mydomain.tld";

  #   # It's also possible to override the target SSH port.
  #   # For further customization, use the SSH_CONFIG_FILE
  #   # environment variable to specify a ssh_config file.
  #   deployment.targetPort = 1234;

  #   # Override the default for this target host
  #   deployment.replaceUnknownProfiles = false;

  #   # You can filter hosts by tags with --on @tag-a,@tag-b.
  #   # In this example, you can deploy to hosts with the "web" tag using:
  #   #    colmena apply --on @web
  #   # You can use globs in tag matching as well:
  #   #    colmena apply --on '@infra-*'
  #   deployment.tags = [ "web" "infra-lax" ];

  #   time.timeZone = "America/Los_Angeles";

  #   boot.loader.grub.device = "/dev/sda";
  #   fileSystems."/" = {
  #     device = "/dev/sda1";
  #     fsType = "ext4";
  #   };
  # };
}