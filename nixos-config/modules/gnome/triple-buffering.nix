{pkgs, ...}: {
  #  BROkEN FILE -x-x  BROkEN FILE -x-x  BROkEN FILE -x-x  BROkEN FILE -x-x BROkEN FILE -x-x
  # https://wiki.nixos.org/wiki/GNOME#Dynamic_triple_buffering
  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (_final: prev: {
      gnome = prev.gnome.overrideScope (
        _gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (_old: {
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.gnome.org";
              owner = "vanvugt";
              repo = "mutter";
              rev = "triple-buffering-v4-46";
              hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
            };
          });
        }
      );
    })
  ];
}
