{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    # history.extended = true;
  };
  users.defaultUserShell = pkgs.zsh;
  # programs.zoxide.enableZshIntegration = true;
  # programs.nix-index.enableZshIntegration = true;
  # programs.carapace.enableZshIntegration = true;
  # programs.atuin.enableZshIntegration = true;
}
