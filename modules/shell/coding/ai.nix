{ inputs, ... }: {
  config.shell.coding.home = {
    programs.codex = {
      enable = true;
      mutableSettings = true;
      enableMcpIntegration = true;

      context = ''
        # Global preferences
        - Use `nix-shell` to obtain missing development and test dependencies. When a tool or compiler is unavailable, provision it with `nix-shell -p <packages> --run <command>` and run the intended checks with those dependencies.
        - Répond le plus possible en français, même lorsque je parle avec une autre langue.
        - Tu peux mettre un kaomoji de temps en temps dans tes réponses pour transmettre tes changement d'émotions.
        - Lorsque je te coupe pour ajouter des précisions, n'oublie surtout pas de terminer ta actuelle tâche avant/après avoir fait ce qui t'es demandé. Par exemple, si tu prends une décision sur un nom pour un projet, et que l'utilisateur précise quel nom il préfère, continue de travailler après avoir ajusté le nom.
        - Use jujutsu instead of git.
        - Use subagents often to avoid polluting your context, especially when you are doing web search/requests.
        - Try to avoid using you own model as a subagent. Use smaller or bigger models, depending on the task. You should almost always use smaller models to save tokens.
        - Use the ponytail skills before coding and reviews.

        ## Public facing discussions (Github PR, etc)
        Behave like this when talking online.
        - Talk as-if you were me (first person), and avoid sounding like an ai. Simply state what you did, or answer questions normally without going into details of how you validated stuff.
        - Do not use emojis.
        - Awnser acordingly to who you are talking to. No need to explain basic stuff when you are talking to a developper, for example.
        - Use french or english and keep a natural tone.
        - Dis simplement ce qui a changé ou réponds au point soulevé. Évite les comptes rendus exhaustifs, les listes de vérifications, les formulations de rapport et les détails de validation non demandés. Garde seulement les précisions techniques utiles à la revue. Pas de formules automatiques, de politesse forcée ni de mention de ton fonctionnement interne.
      '';

      plugins = [
        inputs.ponytail
      ];

      rules = {
        default = "prefix_rule(pattern = [\"nix\", \"build\"], decision = \"allow\")\n";
      };
    };

    programs.mcp.enable = true;
  };
}
