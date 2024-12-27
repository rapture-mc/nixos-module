# To Do...

## Create an automated markdown module documentation system

Something like this could work...
```
let
  nixpkgs = import <nixpkgs> {};
  lib = nixpkgs.lib;

  # evaluate our options
  eval = lib.evalModules {
    modules = [
      ./modules/config/system.nix
    ];
  };
  # generate our docs
  optionsDoc = nixpkgs.nixosOptionsDoc {
    inherit (eval) options;
  };
in
# create a derivation for capturing the markdown output
nixpkgs.runCommand "options-doc.md" {} ''
    cat ${optionsDoc.optionsCommonMark} >> $out
''
```
---
Then add this to any module to not enumerate nixos modules
```
config = {
  _module.check = false; 
};
```
