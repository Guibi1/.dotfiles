{
    ### HOME MANAGER ###

    home-dir = "/home/guibi";

    git = {
        # If git should be enabled
        enable = true;
        # Id of the GPG key to use for git signing
        gpgKey = "";
    };

    enable-hyprland = false;


    ### NIX OS ###

    enable-fprint = false;

    # The credentials to use for the eduroam wifi
    eduroam = {
        identity = "";
        password = "";
    };
}
