{pkgs, ...}: let
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.hyprpaper}/bin/hyprpaper &
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = ''${startupScript}/bin/start'';

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";

      bind = [
        "$mainMod, P, exec, $browser"
        "$mainMod, O, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"

        # Window Navigation
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Window Resizing
        "$mainMod SHIFT, H, resizeactive, -10 0"
        "$mainMod SHIFT, L, resizeactive, 10 0"
        "$mainMod SHIFT, K, resizeactive, 0 -10"
        "$mainMod SHIFT, J, resizeactive, 0 10"

        # Workspace Navigation
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
      ];

      misc = {
        "disable_hyprland_logo" = true;
      };

      decoration = {
        "rounding" = 10;
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "${./desktop-wallpaper.jpg}";
      wallpaper = "eDP-1, ${./desktop-wallpaper.jpg}";
    };
  };
}
