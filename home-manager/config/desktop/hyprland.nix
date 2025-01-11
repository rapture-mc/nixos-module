{ pkgs, ... }: let
  startupScript = pkgs.writeShellScriptBin "startupScript" ''
    ${pkgs.swww}/bin/swww-daemon --no-cache &

    sleep 1

    ${pkgs.swww}/bin/swww img ${./desktop-wallpaper.jpg} &
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = "${startupScript}/bin/startupScript";

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
}
