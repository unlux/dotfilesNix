{pkgs, pkgs-stable, ...}: {
  environment.systemPackages =
    # Use stable Python to avoid docutils 0.22.4 bug in unstable
    (with pkgs-stable; [
      python312
      python312Packages.pip
      python312Packages.virtualenv
    ])
    ++ (with pkgs; [
      poetry
      uv # Fast Python package installer
      ruff # Fast Python linter
    ]);

  # Optional: Set up environment variables
  environment.variables = {
    PYTHONPATH = "$HOME/.local/lib/python3.12/site-packages:$PYTHONPATH";
  };
}
