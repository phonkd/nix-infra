# Setup

## Baremetal (boot iso) setup
1. On your host machine (not in the config for the new machine) add this line and rebuild: 
```
nixboot.binfmt.emulatedSystems = [ "aarch64-linux" ];
```
```
nixos-rebuild switch
```
2. In the raspy directory generate the image: 
```bash
nixos-generate --system aarch64-linux -f sd-aarch64-installer -c nixos-generate.nix
```
(be very patient)

## Colemna (deploy real config)