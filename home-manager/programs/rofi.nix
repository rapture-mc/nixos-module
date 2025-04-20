{ config, ...}: {
  programs.rofi = {
    enable = true;
    theme = let
      inherit
        (config.lib.formats.rasi)
        mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#24283b";
        hv = mkLiteral "#9274ca";
        primary = mkLiteral "#C5C8C6";
        ug = mkLiteral "#0B2447";
        font = "Monospace 11";
        background-color = "@bg";
        dark = "@bg";
        border = "0px";
        kl = "#7aa2f7";
        black = "#000000";
        transparent = "rgba(46,52,64,0)";
      };
    };
  };
}
