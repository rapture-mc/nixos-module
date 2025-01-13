{pkgs, ...}: let
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.hyprpaper}/bin/hyprpaper &
    ${pkgs.waybar}/bin/waybar &
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

        # Workspace Navigation
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
      ];

      binde = [
        # Window Resizing
        "$mainMod SHIFT, H, resizeactive, -30 0"
        "$mainMod SHIFT, L, resizeactive, 30 0"
        "$mainMod SHIFT, K, resizeactive, 0 -30"
        "$mainMod SHIFT, J, resizeactive, 0 30"
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

  programs.waybar = {
    enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "bottom";
        position = "bottom";
        mod = "dock";
        exclusive = true;
        gtk-layer-shell = true;
        margin-bottom = -1;
        passthrough = false;
        modules-left = [
          "custom/os_button"
          "hyprland/workspaces"
          "wlr/taskbar"
        ];
        modules-center = [];
        modules-right = [
          "cpu"
          "temperature"
          "memory"
          "disk"
          "tray"
          "pulseaudio"
          "network"
          "battery"
          "hyprland/language"
          "clock"
        ];
        "hyprland/language" = {
          format = "{}";
          format-en = "ENG";
          format-ru = "PYC";
        };
      };
    };
  };
}
