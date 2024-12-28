{ appimageTools, fetchurl, ... }:
let
  pname = "UnstoppableSwap";
  version = "1.0.0-rc.11";

  src = fetchurl {
    url = "https://github.com/UnstoppableSwap/core/releases/download/${version}/${pname}_${version}_amd64.AppImage";
    hash = "";
  };
in
{
  environment.systemPackages = [
    (appimageTools.wrapType2 {
      inherit pname version src;
    })
  ];
}
