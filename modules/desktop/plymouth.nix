{ ... }: {
  config.desktop.nixos = { pkgs, ... }:
    let
      themeName = "hyprlock";
      theme = pkgs.runCommand "plymouth-theme-${themeName}" { } ''
        themeDir="$out/share/plymouth/themes/${themeName}"
        mkdir -p "$themeDir"
        cp ${./plymouth-theme/wallpaper.png} "$themeDir/wallpaper.png"
        cp ${./plymouth-theme/progress_box.png} "$themeDir/progress_box.png"
        cp ${./plymouth-theme/progress_bar.png} "$themeDir/progress_bar.png"
        cp ${./plymouth-theme/input-field.png} "$themeDir/input-field.png"
        cp ${./plymouth-theme/theme.script} "$themeDir/${themeName}.script"
        cat > "$themeDir/${themeName}.plymouth" <<EOF
        [Plymouth Theme]
        ModuleName=script
        [script]
        ImageDir=$out/share/plymouth/themes/${themeName}
        ScriptFile=$out/share/plymouth/themes/${themeName}/${themeName}.script
        EOF
      '';
    in
    {
      boot.plymouth = {
        enable = true;
        theme = themeName;
        themePackages = [ theme ];
        font = "${pkgs.cascadia-code}/share/fonts/opentype/CascadiaCodePL-Regular.otf";
      };
    };
}
