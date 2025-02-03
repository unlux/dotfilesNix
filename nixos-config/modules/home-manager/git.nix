{...}: {
  programs = {
    git = {
      enable = true;
      userName = "lakshay choudhary";
      userEmail = "lakshaychoudhary77712@gmail.com";
      extraConfig.init = {
        defaultBranch = "main";
        help.autocorrect = "1";
        diff.algorithm = "histogram";
        transfer.fsckobjects = true;
        fetch.fsckobjects = true;
        receive.fsckObjects = true;
        core.excludeFile = "~/.gitignore";
        core.pager = "delta";
        gpg.format = "ssh";
      };
    };
  };
}
