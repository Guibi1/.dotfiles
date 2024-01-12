{
    ### HOME MANAGER ###

    git = {
        # If git should be enabled (it probably shouldn't be on WSL)
        enable = true;
        # Id of the GPG key to use for git signing
        git.gpgKey = "";
    };

    enableHyprland = false;


    ### NIX OS ###

    # The credentials to use for the eduroam wifi
    eduroam = {
        identity = "";
        password = "";
    };
}
