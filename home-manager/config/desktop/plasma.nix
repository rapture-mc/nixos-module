_:

{
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = ./desktop-wallpaper.jpg;
    };
    input.touchpads = [
      {
        naturalScroll = true;
        vendorId = "04f3";
      }
    ];
  };
}
