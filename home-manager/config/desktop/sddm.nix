{pkgs, ...}:

{
  services.displayManager.sddm.theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";
}
