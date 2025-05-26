{ config }: let
  cfg = config.megacorp.services.domain-controller;
in ''
  dn: ${cfg.domain-component}
  objectClass: domain
  dc: megacorp

  dn: ou=Users,${cfg.domain-component}
  objectClass: organizationalUnit
  ou: Users

  dn: ou=IT,ou=Users,${cfg.domain-component}
  objectClass: organizationalUnit
  ou: IT

  dn: ou=Finance,ou=Users,${cfg.domain-component}
  objectClass: organizationalUnit
  ou: Finance

''
