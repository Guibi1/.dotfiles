# Temporary nixpkgs backport

CLI packaging from [nixpkgs#555814](https://github.com/NixOS/nixpkgs/pull/555814)
(commit `41b4f5e699a117fc829487d898532d653c3e90dd`), updated to T3 Code 0.1.8 (latest stable as of 2026-11-10).

Integrated changes:

- [#582335](https://github.com/NixOS/nixpkgs/pull/582335): use nixpkgs Chromium for browser previews, including its sandbox profile and setup detection. Supersedes the downloaded-browser library workaround in #575675.
- [#582628](https://github.com/NixOS/nixpkgs/pull/582628): stage runtime dependencies and skip stripping text files; adapted to the CLI workspace.
- [#555921](https://github.com/NixOS/nixpkgs/pull/555921): bake public T3 Connect identifiers into the web client.
- HTTP startup smoke test from [#575675](https://github.com/NixOS/nixpkgs/pull/575675), adjusted to retry while the server returns a startup HTTP 503.

The CLI is selected in `modules/systems/apollon.nix`. The desktop variant from
#555814 is selected in `modules/desktop/t3code.nix`; both share this source
derivation and its fixes. Apollon runs the CLI backend through Home Manager's
`programs.t3code.server`, with user lingering enabled so it starts at boot.
Replace these backports with nixpkgs packages once the changes land in the pinned nixpkgs.

Build Apollon's Home Manager configuration with:

```sh
nix build path:.#nixosConfigurations.Apollon.config.home-manager.users.guibi.home.activationPackage
```

Use `Artemis` instead of `Apollon` to build the desktop configuration.
Run the dependency staging tests with `python3 packages/t3code-cli/test-stage-runtime.py`.
The shared unwrapped derivation exposes `tests.web`, `tests.browser` (NixOS VM),
and `tests.runtime-dependencies`.
