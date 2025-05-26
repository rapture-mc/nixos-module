{
  lib,
  config,
  nixpkgs,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.domain-controller;

  version = "2.10.4";

  godap = pkgs.buildGoModule {
    pname = "godap";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "Macmod";
      repo = "godap";
      rev = "v${version}";
      hash = "sha256-mvzVOuFZABGE7DH3AkhOXvsvSZzgpW0aJUdXW6N6hf0=";
    };

    vendorHash = "sha256-NiNhKbf5bU1SQXFTZCp8/yNPc89ss8go6M2867ziqq4=";

    meta = with nixpkgs.lib; {
      homepage = "https://github.com/Macmod/godap";
      description = "TUI for LDAP";
      license = licenses.mit;
    };
  };

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in {
  options.megacorp.services.domain-controller = {
    enable = mkEnableOption "Enable domain controller";

    logo = mkEnableOption "Enable domain controller logo";

    domain-component = mkOption {
      type = types.str;
      default = "dc=megacorp,dc=local";
      description = ''
        The domain component in LDAP format.

        Example: dc=megacorp,dc=industries
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ godap ];

    networking.firewall.allowedTCPPorts = [
      389
    ];

    services.openldap = {
      enable = true;

      /*
      enable plain connections only
      */
      urlList = [
        "ldap:///"
      ];

      settings = {
        attrs = {
          olcLogLevel = "conns config";
        };

        children = {
          "cn=schema".includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            "${pkgs.openldap}/etc/schema/nis.ldif"
          ];

          "olcDatabase={1}mdb".attrs = {
            objectClass = ["olcDatabaseConfig" "olcMdbConfig"];

            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/lib/openldap/data";

            olcSuffix = cfg.domain-component;

            olcRootDN = "cn=admin,${cfg.domain-component}";
            olcRootPW.path = "/run/secrets/olcRootPW";

            olcAccess = [
              /*
              custom access rules for userPassword attributes
              */
              ''              {0}to attrs=userPassword
                                by self write
                                by anonymous auth
                                by * none''

              /*
              allow read on anything else
              */
              ''              {1}to *
                                by * read''
            ];
          };
        };
      };

      declarativeContents = {
        "${cfg.domain-component}" =
          (import ./ou-structure.nix {inherit config;})
          + import ./users.nix;
      };
    };
  };
}
