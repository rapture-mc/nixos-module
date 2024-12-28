{ pkgs, ... }:
let
  pname = "UnstoppableSwap";
  version = "1.0.0-rc.11";

  src = pkgs.fetchurl {
    url = "https://github.com/UnstoppableSwap/core/releases/download/${version}/${pname}_${version}_amd64.AppImage";
    hash = "sha256-ot9yHm2mUaFJL9G80T6VhzYrpRmoSR9wUL79tnZiuyA=";
  };
in
{
  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2 {
      inherit pname version src;
    })
  ];
}
