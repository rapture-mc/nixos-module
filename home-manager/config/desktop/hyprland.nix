{ pkgs, ... }: let
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww-daemon &

    sleep 1

    ${pkgs.swww}/bin/swww img ${./desktop-wallpaper.jpg} &
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;

    systemd.enable = true;

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
}
