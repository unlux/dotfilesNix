final: prev: let
  lib = prev.lib;
  wrapDesktop = pkg:
    pkg.overrideAttrs (old: {
      # Ensure the desktop entry always uses nvidia-offload and the desired WM class
      postInstall =
        (old.postInstall or "")
        + ''
          set -eu
          # Update any Zen desktop files shipped by the package
          if [ -d "$out/share/applications" ]; then
            for f in "$out/share/applications"/zen*.desktop "$out/share/applications"/*zen*.desktop; do
              [ -f "$f" ] || continue
              sed -i -E 's|^Exec=.*|Exec=nvidia-offload zen %U|' "$f"
              if grep -q '^StartupWMClass=' "$f"; then
                sed -i -E 's|^StartupWMClass=.*|StartupWMClass=zen-browser|' "$f"
              else
                printf '\nStartupWMClass=zen-browser\n' >> "$f"
              fi
            done
          fi
        '';
    });
in
  # Override the likely zen package attribute names, only if they exist
  lib.optionalAttrs (prev ? zen) {
    zen = wrapDesktop prev.zen;
  }
  // lib.optionalAttrs (builtins.hasAttr "zen-browser" prev) {
    "zen-browser" = wrapDesktop prev."zen-browser";
  }
  // lib.optionalAttrs (builtins.hasAttr "zen-beta" prev) {
    "zen-beta" = wrapDesktop prev."zen-beta";
  }
  // lib.optionalAttrs (builtins.hasAttr "zen-browser-beta" prev) {
    "zen-browser-beta" = wrapDesktop prev."zen-browser-beta";
  }
