{ pkgs, ... }: let
  startupScript = pkgs.writeShellScriptBin "start" ''
    sleep 1

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
      ];
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
