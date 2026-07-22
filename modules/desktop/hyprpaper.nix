{ ... }: {
  config.desktop.home = {
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "~/Images/wallpaper.png";
          }
        ];
      };
    };
  };
}
