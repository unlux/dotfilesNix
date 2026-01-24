{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [pkgs.ydotool];

  # udev rule to allow users group to access /dev/uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="users", MODE="0660", OPTIONS+="static_node=uinput"
  '';

  # User-level systemd service for ydotoold
  systemd.user.services.ydotoold = {
    description = "ydotool daemon for virtual input";
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-path=%t/.ydotool_socket --socket-own=%U:%G";
      Restart = "always";
      RestartSec = 3;
    };
  };

  # Add user to users group for uinput access
  users.users.lux.extraGroups = ["users"];

  # Flatpak override for Speech Note - needs access to XDG_RUNTIME_DIR
  services.flatpak.overrides."net.mkiol.SpeechNote" = {
    Context.filesystems = ["xdg-run/.ydotool_socket"];
    Environment.YDOTOOL_SOCKET = "/run/user/1000/.ydotool_socket";
  };
}
