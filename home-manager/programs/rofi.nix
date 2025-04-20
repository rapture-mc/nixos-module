{ config, ...}: {
  programs.rofi = {
    enable = true;
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#24283b";
        hv = mkLiteral "#9274ca";
        primary = mkLiteral "#C5C8C6";
        ug = mkLiteral "#0B2447";
        font = "Monospace 11";
        background-color = "@bg";
        # dark = "@bg";
        border = "0px";
        kl = "#7aa2f7";
        black = "#000000";
        transparent = "rgba(46,52,64,0)";
      };

      "window" = {
        width = 700;
        orientation = mkLiteral "horizontal";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        transparency = "screenshot";
        border-color = mkLiteral "@transparent";
        border = mkLiteral "0px";
        border-radius = mkLiteral "6px";
        spacing = 0;
        children = [ "mainbox" ];
      };

      "mainbox" = {
        spacing = 0;
        children = [ "inputbar" "message" "listview" ];
      };

      "inputbar" = {
        color = mkLiteral "@kl";
        padding = mkLiteral "11px";
        border = mkLiteral "3px 3px 2px 3px";
        border-color = mkLiteral "@primary";
        border-radius = mkLiteral "6px 6px 0px 0px";
      };

      "message" = {
        padding = 0;
        border-color = mkLiteral "@primary";
        border = mkLiteral "0px 1px 1px 1px";
      };

      "entry, prompt, case-indicator" = {
        text-font = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "entry" = {
        cursor = mkLiteral "pointer";
      };

      "prompt" = {
        margin = mkLiteral "0px 5px 0px 0px";
      };

      "listview" = {
        layout = mkLiteral "vertical";
        padding = "5px";
        lines = 12;
        colums = 1;
        border = "0px 3px 3px 3px";
        border-radius = "0px 0px 6px 6px";
        border-color = "@primary";
        dynamic = "false";
      };

      "element" = {
        padding = "2px";
        vertical-align = 1;
        color = "@kl";
        font = "inherit";
      };

      "element-text" = {
        background-color = "inherit";
        text-color = "inherit";
      };

      "element selected.normal" = {
        color = "@black";
        background-color = "@hv";
      };

      "element normal active" = {
        background-color = "@hv";
        color = "@black";
      };

      "element-text, element-icon" = {
        background-color = "inherit";
        text-color = "inherit";
      };

      "element normal urgent" = {
        background-color = "@primary";
      };

      "element selected active" = {
        background = "@hv";
        foreground = "@bg";
      };

      "button" = {
        padding = "6px";
        color = "@primary";
        horizontal-align = "0.5";
        border = "2px 0px 2px 2px";
        border-radius = "4px 0px 0px 4px";
        border-color = "@primary";
      };

      "button selected normal" = {
        border = "2px 0px 2px 2px";
        border-color = "@primary";
      };

      "scrollbar" = {
        enabled = "true;";
      };
    };
  };
}
