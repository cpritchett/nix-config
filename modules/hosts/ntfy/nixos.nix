{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.cpritchett.ntfy;
in
{
  options.cpritchett.ntfy = {
    ntfyUrl = mkOption {
      type = types.str;
      default = "";
      description = "The base URL for NTFY notifications.";
    };

    defaultTopic = mkOption {
      type = types.str;
      default = "";
      description = "The default topic for NTFY notifications.";
    };

    defaultPriority = mkOption {
      type = types.str;
      default = "";
      description = "The default priority level for NTFY notifications.";
    };
  };

  config = {
    cpritchett.ntfy = {
      ntfyUrl = "https://azure-ntfy.lynx-justice.ts.net/";
      defaultTopic = "ntfy";
      defaultPriority = "p:3";
    };
  };
}

# example:
# "curl -H ${config.cpritchett.ntfy.defaultPriority} -d "message goes here" ${config.cpritchett.ntfy.ntfyUrl}${config.cpritchett.ntfy.defaultTopic}"