{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    (pkgs.nerdfonts.override {fonts = [meslo-lgs-nf "JetBrainsMono"];})
    cm_unicode
    corefonts
  ];
}
