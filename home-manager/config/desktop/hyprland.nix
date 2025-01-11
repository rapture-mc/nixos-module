{ pkgs, ... }: let
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww-daemon &

    sleep 1

  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = ''
        ${startupScript}/bin/start

        ${pkgs.swww}/bin/swww img ${./desktop-wallpaper.jpg} &
      '';

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
