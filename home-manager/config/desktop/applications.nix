{
  osConfig,
  lib,
  ...
}: {
  xdg.desktopEntries = {
    UnstoppableSwap = lib.mkIf osConfig.megacorp.virtualisation.whonix.enable {
      name = "UnstoppableSwap";
      genericName = "XMR Swap";
      exec = "UnstoppableSwap";
      terminal = false;
      icon = ./unstoppable-swap.svg;
    };

    StartWhonix = lib.mkIf osConfig.megacorp.virtualisation.whonix.enable {
      name = "Start Whonix";
      exec = "startWhonix";
      terminal = false;
      icon = ./whonix.svg;
    };

    StopWhonix = lib.mkIf osConfig.megacorp.virtualisation.whonix.enable {
      name = "Stop Whonix";
      exec = "stopWhonix";
      terminal = false;
      icon = ./whonix.svg;
    };
  };
}
