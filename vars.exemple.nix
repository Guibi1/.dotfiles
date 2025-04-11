{
    hostname = "NixPC";
    home-dir = "/home/guibi";

    ### HOME MANAGER ###
    enable-hyprland = false;

    git = {
        # If git should be enabled
        enable = true;
        # Id of the GPG key to use for git signing
        # gpgKey = "";
        # Location of the SSH key file to use for git signing
        # sshKey = "";
    };

    ### NIX OS ###
    enable-fprint = false;
    server = false;

    # The credentials to use for the eduroam wifi
    eduroam = {
        identity = "";
        password = "";
    };
}
