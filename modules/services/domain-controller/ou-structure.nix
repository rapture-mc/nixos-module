{ config }: let
  cfg = config.megacorp.services.domain-controller;
in ''
  dn: ${cfg.domain-component}
  objectClass: domain
  dc: megacorp

  dn: ou=Users,dc=megacorp,dc=industries
  objectClass: organizationalUnit
  ou: Users

  dn: ou=IT,ou=Users,dc=megacorp,dc=industries
  objectClass: organizationalUnit
  ou: IT

  dn: ou=Finance,ou=Users,dc=megacorp,dc=industries
  objectClass: organizationalUnit
  ou: Finance

''
