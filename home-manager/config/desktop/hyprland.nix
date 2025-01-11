_: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";

      bind = [
        "$mainMod, P, exec, $browser"
        "$mainMod, O, exec, $terminal"
        "$mainMod, Q, killactive,"
      ];
    };
  };
}
