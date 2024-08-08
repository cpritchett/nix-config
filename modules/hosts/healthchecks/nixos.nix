{ options, config, lib, pkgs, inputs, ... }:

let
  cfg = config.cpritchett.healthcheckUrl;
in
{
  options.cpritchett.healthcheckUrl = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.attrs;
    };
    default = {};
    description = "A submodule for health check URLs.";
  };

  config = {
    cpritchett.healthcheckUrl = {
      syncoid = {
        smalt = "https://azure-healthchecks.lynx-justice.ts.net/ping/47dc1f57-6780-4246-8052-4bf5cb4bbddd";
        teal = "https://azure-healthchecks.lynx-justice.ts.net/ping/54c781e4-7f67-42ec-89de-16f98ba55d9f";
        carob = "https://azure-healthchecks.lynx-justice.ts.net/ping/73e0cf2b-5ccc-40cc-8f9e-badbe053e5b4";
        azure = "https://azure-healthchecks.lynx-justice.ts.net/ping/53d019ba-c0f5-4354-8335-98eca466e15d";
      };
      nixos-upgrade = {
        blue = "https://azure-healthchecks.lynx-justice.ts.net/ping/9119da9b-5e5c-4bff-9bd5-981a00f05878";
        smalt = "https://azure-healthchecks.lynx-justice.ts.net/ping/e3e54e29-93ed-45fd-8dd6-5a99cf5d61ce";
        azure = "https://azure-healthchecks.lynx-justice.ts.net/ping/d84050d8-b21f-45e2-b2b1-b009615a441e";
        carob = "https://azure-healthchecks.lynx-justice.ts.net/ping/9de5edba-a351-4968-a434-7ee00026a37a";
        teal = "https://azure-healthchecks.lynx-justice.ts.net/ping/a0e00318-05d3-4095-8d8b-0944b8d203e0";
      };
    };
  };
}
