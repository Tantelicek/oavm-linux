{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.system.users;
in {
  options = {
    system.users = {
      enable = lib.mkEnableOption "Nastavení uživatelských účtů";
    };
  };

  config = lib.mkIf cfg.enable {
    #Student
    users.users.student = {
      isNormalUser = true;
      description = "Student OAVM";
      extraGroups = ["networkmanager"];
      initialPassword = "";
      packages = with pkgs; [
      ];
    };

    #Admin

    users.users.admin = {
      isNormalUser = true;
      description = "Admin OAVM";
      extraGroups = ["networkmanager" "wheel"];
      hashedPassword = "$y$j9T$Odk1GT4FQF5yfi4WBtQVd.$8RvSotMRIBVpvxUieg7XRJBJHJ/qeiBFzXqI4QCjFUC";
      packages = with pkgs; [
      ];
    };
  };
}
