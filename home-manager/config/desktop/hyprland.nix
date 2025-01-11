_: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";

      bind = [
        "$mainMod, W, exec, $browser"
        "$mainMod, Q, exec, $terminal"
      ];
    };
  };
}
