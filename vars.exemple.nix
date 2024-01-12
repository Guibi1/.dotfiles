{
    ### HOME MANAGER ###

    git = {
        # If git should be enabled
        enable = true;
        # Id of the GPG key to use for git signing
        gpgKey = "";
    };

    enableHyprland = false;


    ### NIX OS ###

    # The credentials to use for the eduroam wifi
    eduroam = {
        identity = "";
        password = "";
    };
}
