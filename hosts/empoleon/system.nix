{ __findFile, ... }: {
  den.hosts.x86_64-linux.empoleon = {
    users.avery = { };
  };

  hosts.empoleon = {
    description = "Personal laptop";

    includes = [
      <megurine/is/desktop>
      <megurine/has/bluetooth>
      <megurine/has/intel-cpu>
      <megurine/has/intel-cpu/kvm>
      <megurine/has/wifi>
      <megurine/requires/secure-boot>
    ];

    nixos = {
      i18n = {
        defaultLocale = "es_ES.UTF-8";
        supportedLocales = [
          "C.UTF-8/UTF-8"
          "en_US.UTF-8/UTF-8"
          "es_ES.UTF-8/UTF-8"
        ];
      };

      time.timeZone = "Europe/Madrid";
    };
  };
}
