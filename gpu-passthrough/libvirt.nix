{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.virtualisation.libvirtd;

  boolToZeroOne = x: if x then "1" else "0";

  aclString = with lib.strings;
    concatMapStringsSep ''
      ,
        '' escapeNixString cfg.deviceACL;
in {
  options.virtualisation.libvirtd = {
    deviceACL = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    clearEmulationCapabilities = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.virtualisation.libvirtd.qemuVerbatimConfig = ''
    clear_emulation_capabilities = ${
      boolToZeroOne cfg.clearEmulationCapabilities
    }
    cgroup_device_acl = [
      ${aclString}
    ]
  '';

  #config.services.udev.extraRules = ''
  #  SUBSYSTEM=="usb", ATTR{"DEVPATH"}=="/dev/input/by-id/usb-04d9_USB_Keyboard-event-kbd", GROUP="wheel"
  #''; 
}
