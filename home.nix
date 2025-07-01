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
        yubikey-manager23

        # Fish/Terminal
        grc fzf

        # Dev env
        bun nodejs_22 # TypeScript
        rustup # Rust
        nixd nil # Nix
        python3Full ruff # Python
        openjdk21_headless jdt-language-server # Java

        ripgrep fd bat eza hyperfine tokei
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
                { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
                { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
            ];
            shellAliases = {
                cat = "bat";
                ls = "exa";
            };
        };

        # Starship prompt config
        starship = {
            enable = true;
            enableFishIntegration = true;
            enableTransience = true;
            settings = {
                add_newline = true;

                character = {
                    # Note the use of Catppuccin color 'peach'
                    success_symbol = "[[󰄛](green) ❯](peach)";
                    error_symbol = "[[󰄛](red) ❯](peach)";
                    vimcmd_symbol = "[󰄛 ❮](subtext1)"; # For use with zsh-vi-mode
                };

                git_branch = {
                    style = "bold mauve";
                };

                directory = {
                    truncation_length = 4;
                    style = "bold lavender";
                };

                palette = "catppuccin_mocha";
                palettes.catppuccin_mocha = {
                    rosewater = "#f5e0dc";
                    flamingo = "#f2cdcd";
                    pink = "#f5c2e7";
                    mauve = "#cba6f7";
                    red = "#f38ba8";
                    maroon = "#eba0ac";
                    peach = "#fab387";
                    yellow = "#f9e2af";
                    green = "#a6e3a1";
                    teal = "#94e2d5";
                    sky = "#89dceb";
                    sapphire = "#74c7ec";
                    blue = "#89b4fa";
                    lavender = "#b4befe";
                    text = "#cdd6f4";
                    subtext1 = "#bac2de";
                    subtext0 = "#a6adc8";
                    overlay2 = "#9399b2";
                    overlay1 = "#7f849c";
                    overlay0 = "#6c7086";
                    surface2 = "#585b70";
                    surface1 = "#45475a";
                    surface0 = "#313244";
                    base = "#1e1e2e";
                    mantle = "#181825";
                    crust = "#11111b";
                };
            };
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
