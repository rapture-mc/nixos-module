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

        "$mainMod, left, movefocus, h"
        "$mainMod, right, movefocus, l"
        "$mainMod, up, movefocus, k"
        "$mainMod, down, movefocus, j"

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
