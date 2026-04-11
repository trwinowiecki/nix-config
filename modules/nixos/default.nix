{
  pkgs,
  config,
  lib,
  inputs,
  outputs,
  myLib,
  ...
}: let
  cfg = config.myNixOS;

  # Desktop environment names for mutual exclusion
  desktopEnvs = ["gnome" "kde" "hyprland" "niri"];
  enabledDEs = lib.filter (de: cfg.desktop.${de}.enable or false) desktopEnvs;

  # Taking all modules in ./features (excluding desktop directory) and adding enables to them
  featureFiles = lib.filter
    (f: !(lib.hasSuffix "/desktop" (toString f)))
    (myLib.filesIn ./features);

  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    featureFiles;

  # Desktop environment features with myNixOS.desktop.<name>.enable
  desktopFeatures =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.desktop.${name}.enable = lib.mkEnableOption "enable ${name} desktop environment";
      };

      configExtension = config: (lib.mkIf cfg.desktop.${name}.enable config);
    })
    (myLib.filesIn ./features/desktop);

  # Taking all module bundles in ./bundles and adding bundle.enables to them
  bundles =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
      };

      configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
    })
    (myLib.filesIn ./bundles);
in {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ features
    ++ desktopFeatures
    ++ bundles;

  config = {
    # Mutual exclusion assertion for desktop environments
    assertions = [
      {
        assertion = builtins.length enabledDEs <= 1;
        message = ''
          Only one desktop environment can be enabled at a time.
          Currently enabled: ${lib.concatStringsSep ", " enabledDEs}
        '';
      }
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];
    programs.nix-ld.enable = true;
    # allowUnfree is set in myLib/default.nix via mkSystem/mkHome
  };
}
