let
  agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkt8xgN5ZlTyuSBWAhlv0CCxIN6LmzfSMTHTc53rZ6i";
  cpritchett = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEYoH0dcCQP4sFB3Jl3my7tqXdcwvHo0mOdDdB39UFX";
  flotilla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjiQ3f+w/MJtFbTMm7v7txv6J1zSFBK/HvD5chT8nQ+";
  test-macos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5MIKopbucuTTqbbdtbIMQriJcmbec/JV6Xv2XOrlsn"
  test-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEslyZfQK3WAhii3Pe3BQBMyhUUHd/edbhrsxW9V8poB"

  # keys to work for all secrets
  all = [ agenix cpritchett flotilla test-macos test-nixos ];

in
{
  "cpritchett.age".publicKeys = [ flotilla ] ++ all;
  "tailscaleKey.age".publicKeys = [ flotilla ] ++ all;
  "tailscaleOAuthKeyAcceptSsh.age".publicKeys = [ flotilla ] ++ all;
  "tailscaleEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "tailscaleOAuthEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "piholeEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "nextcloudEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "nextcloudDBEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "palworldEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "teslamateEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "teslamateDBEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "teslamateGrafanaEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "semaphoreEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "semaphoreDBEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "homepage.age".publicKeys = [ flotilla ] ++ all;
  "linkwardenEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "linkwardenDBEnvFile.age".publicKeys = [ flotilla ] ++ all;
  "healthchecks.age".publicKeys = [ ] ++ all;




  #example for calling groups
  #"secret2.age".publicKeys = users ++ systems;
} 
