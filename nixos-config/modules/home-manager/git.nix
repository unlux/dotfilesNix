{...}: {
  programs = {
    git = {
      enable = true;
      userName = "lakshay choudhary";
      userEmail = "lakshaychoudhary77712@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        help.autocorrect = "1";
        diff.algorithm = "histogram";
        transfer.fsckObjects = true;
        fetch.fsckObjects = true;
        receive.fsckObjects = true;
        core = {
          excludeFile = "~/.gitignore";
          pager = "delta";
          editor = "nvim";
          autocrlf = "input";
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
        # credential.helper = "store";
        merge = {
          conflictStyle = "diff3";
          tool = "vimdiff";
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
      };
    };
  };
}
