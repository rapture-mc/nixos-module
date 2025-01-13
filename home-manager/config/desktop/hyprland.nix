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
    systemd.enable = true;
    style = ''
      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

      window#waybar {
        background: transparent;
        border-bottom: none;
      }

      * {
        font-size: 18px;
      }
    '';
    settings = [{
      height = 30;
      layer = "top";
      position = "bottom";
      tray = { spacing = 10; };
      modules-center = [ "sway/window" ];
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
      ]
      ++ [
        "clock"
        "tray"
      ];
      battery = {
        format = "{capacity}% {icon}";
        format-alt = "{time} {icon}";
        format-charging = "{capacity}% ";
        format-icons = [ "" "" "" "" "" ];
        format-plugged = "{capacity}% ";
        states = {
          critical = 15;
          warning = 30;
        };
      };
      clock = {
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory = { format = "{}% "; };
      network = {
        interval = 1;
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "Disconnected ⚠";
        format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
        format-linked = "{ifname} (No IP) ";
        format-wifi = "{essid} ({signalStrength}%) ";
      };
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-icons = {
          car = "";
          default = [ "" "" "" ];
          handsfree = "";
          headphones = "";
          headset = "";
          phone = "";
          portable = "";
        };
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        on-click = "pavucontrol";
      };
      "sway/mode" = { format = ''<span style="italic">{}</span>''; };
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "" "" "" ];
      };
    }];
  };
}
