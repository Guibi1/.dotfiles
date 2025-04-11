{ pkgs, lib, ... }:
let
    vars = import ./vars.nix;
    importIf = file: enable: lib.optional enable file;
in
{
    home.username = "guibi";
    home.homeDirectory = lib.mkForce vars.home-dir;
    home.stateVersion = "23.11";

    imports = [./node-global-packages] ++ (importIf ./hyprland vars.enable-hyprland);


    # Packages to install
    home.packages = with pkgs; [
        fastfetch

        # Fish/Terminal
        grc fzf

        # Dev env
        bun nodejs_22 # TypeScript
        rustup # Rust
        nixd nil # Nix
        python3Full ruff # Python
        openjdk21_headless jdt-language-server # Java
    ];


    # Programs config
    programs = {
        # Fish shell config
        fish = {
            enable = true;
            interactiveShellInit = ''
                function fish_greeting
                    fastfetch -c ~/.config/fastfetch/greeting.jsonc
                end
            '';
            plugins = [
                { name = "grc"; src = pkgs.fishPlugins.grc.src; }
                { name = "tide"; src = pkgs.fishPlugins.tide.src; }
                { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
            ];
        };

        # Zoxide (cd replacement)
        zoxide = {
            enable = true;
            options = ["--cmd cd"];
            enableBashIntegration = true;
            enableFishIntegration = true;
        };

        # Git config
        git = {
            enable = vars.git.enable or false;
            userName = "Laurent Stéphenne";
            userEmail = "laurent@guibi.dev";

            # Enable gpg signing if possible
            signing = {
                signByDefault = (vars ? git.gpgKey) || (vars ? git.sshKey);
                key = vars.git.gpgKey or vars.git.sshKey or null;
                format = if vars ? git.sshKey then "ssh" else null;
            };

            # Allows for git difftool to work with vscode
            extraConfig = {
                diff.tool = "vscode";
                "difftool \"vscode\"".cmd = "code --diff $LOCAL $REMOTE";
                pull.rebase = true;
            };
        };

        gpg = {
            enable = true;
        };

        # Let Home Manager install and manage itself
        home-manager.enable = true;
    };

    xdg = {
        enable = true;

        # .config symlinks
        configFile = {
            fastfetch.source = ./dotfiles/fastfetch;
        };
    };


    # Env variables
    home.sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = "1";
        EDITOR = if vars.enable-hyprland then "code --wait" else "nano";
    };
}
