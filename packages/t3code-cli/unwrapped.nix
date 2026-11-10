{
  callPackage,
  chromium,
  runCommand,
  fetchFromGitHub,
  enableDesktop ? false,
  installShellFiles,
  lib,
  libsecret,
  makeBinaryWrapper,
  node-gyp,
  nodejs_26,
  pkg-config,
  python3,
  spdx-license-list-data,
  stdenv,
  fetchPnpmDeps,
  pnpm_12,
  pnpmConfigHook,
  pnpmBuildHook,
  cacert,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    # Upstream package.json requires Node.js 26; the nixpkgs default is still 24.
    nodejs = nodejs_26;
    pnpm = pnpm_12;
    browser = chromium;
    browserProfileName = "t3-nix-${builtins.baseNameOf (toString browser.browser)}";
    withBrowser = lib.elem stdenv.hostPlatform.system [
      "x86_64-linux"
      "aarch64-linux"
    ];

  in
  {
    pname = "t3code-unwrapped";
    version = "0.1.8";
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "pingdotgg";
      repo = "t3code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-QPZpT/1zm5sLIDw3AOzUCIrmOFPwUU8jP/q1A8GzLow=";
    };

    postPatch = ''
      substituteInPlace apps/web/vite.config.ts \
        --replace-fail 'const host = explicitHost || "localhost";' \
                       'const host = explicitHost || "127.0.0.1";'

      cp .env.example .env

      mkdir -p .generated/third-party-licenses/spdx/v3.28.0
      cp ${spdx-license-list-data.json}/json/details/*.json \
        .generated/third-party-licenses/spdx/v3.28.0
    ''
    + lib.optionalString withBrowser ''
      substituteInPlace apps/server/src/preview/PreviewBrowser.ts \
        --replace-fail 'const executable = path.join(installRoot, release.version, executableName);' \
                       'const executable = "${lib.getExe browser}";'

      # Key the profile by store path so setup also runs after browser updates
      # or when an upstream cache-only profile is already installed.
      substituteInPlace apps/server/src/preview/PreviewBrowserHost.ts \
        --replace-fail 't3-chrome-headless-shell' '${browserProfileName}' \
        --replace-fail '/**/tools/chrome-headless-shell/*/*/chrome-headless-shell' \
                       '${browser.browser}/libexec/chromium/chromium'

      substituteInPlace apps/server/src/cli/browser.ts \
        --replace-fail 'const browser = yield* installedBrowser(baseDirPath);' \
                       'const browser = Option.some("${lib.getExe browser}");'
    '';

    nativeBuildInputs = [
      installShellFiles
      makeBinaryWrapper
      node-gyp
      nodejs
      python3
      pnpmConfigHook
      pnpmBuildHook
      pnpm
      cacert
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libsecret ];

    pnpmWorkspaces = [
      # `...` suffix is used to also include other workspace packages that are
      # directly or indirectly depended on by the listed packages, such as
      # `@t3tools/contracts` and `@t3tools/shared`.
      "@t3tools/monorepo"
      "t3..."
      "@t3tools/desktop..."
      "@t3tools/scripts..."
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit pnpm;
      inherit (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        ;

      fetcherVersion = 5;
      hash = "sha256-ir2iMNpT5nA4ieTZT/7v5tawKH137DcfGFuzgxHfJjY=";
    };

    preBuild = ''
      # pnpm otherwise detects the package version updates below as
      # dependency drift and runs another install, including lifecycle scripts.
      export pnpm_config_verify_deps_before_run=false

      node scripts/update-release-package-versions.ts ${finalAttrs.version}

      export npm_config_nodedir=${nodejs}
      export ELECTRON_SKIP_BINARY_DOWNLOAD=1
      # Exclude the `@t3tools/monorepo` workspace from the pending rebuild since
      # `vp config` needs git
      pnpm rebuild --pending "''${pnpmInstallFlags[@]}" --filter '!@t3tools/monorepo'
    '';

    buildPhase = ''
      runHook preBuild
      ${if enableDesktop then "pnpm run build:desktop" else "pnpm exec vp run --filter t3 build"}
      runHook postBuild
    '';

    postBuild = ''
      pnpm vp cache clean
    '';

    # Many dependencies vendors many prebuilt native artifacts for non-host
    # platforms, and some of those binaries are statically linked. Let fixup
    # handle wrappers, shebangs, and stripping, but skip patchelf on the
    # vendored tree.
    dontPatchELF = true;
    # The tmpdir audit hook also shells out to patchelf while scanning every
    # vendored ELF for leaked build paths. That produces spurious warnings on
    # some dependencies' static foreign-platform binaries.
    noAuditTmpdir = true;

    stripExclude = [
      "*.js"
      "*.mjs"
      "*.cjs"
      "*.ts"
      "*.mts"
      "*.cts"
      "*.map"
      "*.json"
      "*.md"
    ];

    installPhase = ''
      runHook preInstall

      mkdir --parents "$out"/libexec/t3code/apps/server
      node --input-type=module > runtime-dependencies.json <<'JS'
      import fs from 'node:fs';
      import { selectCliRuntimeExternalDependencies } from './scripts/lib/cli-external-packages.ts';
      import { selectDesktopRuntimeExternalDependencies } from './scripts/lib/desktop-external-packages.ts';
      const desktop = JSON.parse(fs.readFileSync('apps/desktop/package.json', 'utf8'));
      const server = JSON.parse(fs.readFileSync('apps/server/package.json', 'utf8'));
      console.log(JSON.stringify({
        'apps/server': Object.keys(selectCliRuntimeExternalDependencies(server.dependencies)),
        ...(${if enableDesktop then "true" else "false"} ? {
          'apps/desktop': Object.keys(selectDesktopRuntimeExternalDependencies(desktop.dependencies)),
        } : {}),
      }));
      JS
      python3 ${./stage-runtime.py} . "$out/libexec/t3code" runtime-dependencies.json
      cp --recursive --no-preserve=mode apps/server/dist "$out"/libexec/t3code/apps/server
    ''
    + lib.optionalString enableDesktop ''
      mkdir --parents "$out/libexec/t3code/apps/desktop/prod-resources"
      cp --recursive --no-preserve=mode apps/desktop/{package.json,dist-electron} "$out/libexec/t3code/apps/desktop"
      install -m444 assets/prod/black-universal-1024.png "$out/libexec/t3code/apps/desktop/prod-resources/icon.png"
    ''
    + lib.optionalString (enableDesktop && stdenv.hostPlatform.isLinux) ''
      install -Dm755 native/browser-secret/build/${stdenv.hostPlatform.node.arch}/t3-browser-secret \
        "$out/libexec/t3code/apps/desktop/prod-resources/browser-secret/t3-browser-secret"
    ''
    + ''
      find "$out"/libexec/t3code -xtype l -delete

      makeWrapper ${lib.getExe nodejs} "$out"/bin/t3 \
        --add-flags "$out"/libexec/t3code/apps/server/dist/bin.mjs
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # node-pty tries to chmod this helper at runtime, but the Nix store is
      # immutable by then.
      find "$out"/libexec/t3code \
        -path '*/node-pty/prebuilds/darwin-*/spawn-helper' \
        -exec chmod 755 {} +
    ''
    + ''
      runHook postInstall
    '';

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        installShellCompletion --cmd t3 --"$shell" <("$out/bin/t3" --completions "$shell")
      done
    '';

    postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      # Supply libstdc++ for the bundled node-pty prebuild.
      for module in "$out"/libexec/t3code/node_modules/.pnpm/node-pty@*/node_modules/node-pty/prebuilds/linux-${stdenv.hostPlatform.node.arch}/pty.node; do
        patchelf --add-rpath ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]} "$module"
      done
    '';

    passthru = {
      inherit browser;
      tests.browser = callPackage ./browser-test.nix {
        inherit browser;
        t3code = finalAttrs.finalPackage;
      };
      tests.runtime-dependencies = runCommand "t3code-runtime-dependencies-test" { } ''
        cp ${./stage-runtime.py} stage-runtime.py
        cp ${./test-stage-runtime.py} test-stage-runtime.py
        ${lib.getExe python3} test-stage-runtime.py
        touch "$out"
      '';
      tests.web =
        runCommand "t3code-web-startup-smoke"
          {
            T3CODE_TELEMETRY_ENABLED = "false";
          }
          ''
            export HOME="$TMPDIR"
            export T3CODE_HOME="$HOME/.t3"
            ${lib.getExe python3} ${./web-smoke.py} ${finalAttrs.finalPackage}/bin/t3
            touch "$out"
          '';

    };

    meta = {
      description = "Minimal web GUI for coding agents";
      homepage = "https://t3.codes";
      downloadPage = "https://t3.codes/download";
      changelog = "https://github.com/pingdotgg/t3code/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        _0x4bs3nt
        iamanaws
        qweered
      ];
      inherit (nodejs.meta) platforms;
    };
  }
)
