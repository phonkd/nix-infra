{ config, pkgs, ... }:
{
  system.stateVersion = "24.05"; # Did you read the comment?
  
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

}