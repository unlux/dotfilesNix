{pkgs, ...}: let
  download-sorter-script = pkgs.writeScript "/etc/local/bin/download_sorter.py" ''
    #!/usr/bin/env python3
    import os
    import shutil
    import datetime

    # Define directories
    DOWNLOADS_DIR = os.path.expanduser("~/Downloads")
    PAST_WEEK_DIR = os.path.join(DOWNLOADS_DIR, "1. Past Week")
    PAST_MONTH_DIR = os.path.join(DOWNLOADS_DIR, "2. Past Month")
    OLDER_DIR = os.path.join(DOWNLOADS_DIR, "3. Older")

    ALL_FOLDERS = [PAST_WEEK_DIR, PAST_MONTH_DIR, OLDER_DIR]

    def ensure_dirs():
        """Ensure that sorting directories exist."""
        for directory in ALL_FOLDERS:
            os.makedirs(directory, exist_ok=True)

    def get_file_age(file_path):
        """Get file age as a timedelta object."""
        return datetime.datetime.now() - datetime.datetime.fromtimestamp(os.path.getmtime(file_path))

    def move_and_preserve_metadata(src, dest):
        """Move file while preserving original timestamps."""
        if os.path.dirname(src) == dest:  # Avoid redundant moves
            return

        original_stat = os.stat(src)
        dest_path = os.path.join(dest, os.path.basename(src))

        shutil.move(src, dest_path)

        try:
            os.utime(dest_path, (original_stat.st_atime, original_stat.st_mtime))
        except PermissionError:
            print(f"Warning: Could not modify timestamps for {dest_path}")

    def move_files():
        """Sort files based on age."""
        for folder in [DOWNLOADS_DIR] + ALL_FOLDERS:  # Check all relevant folders
            for item in os.listdir(folder):
                item_path = os.path.join(folder, item)

                if not os.path.isfile(item_path):  # Ignore directories
                    continue

                age = get_file_age(item_path)

                if age < datetime.timedelta(days=7):
                    move_and_preserve_metadata(item_path, PAST_WEEK_DIR)
                elif age < datetime.timedelta(days=30):
                    move_and_preserve_metadata(item_path, PAST_MONTH_DIR)
                else:
                    move_and_preserve_metadata(item_path, OLDER_DIR)

    def main():
        ensure_dirs()
        move_files()

    if __name__ == "__main__":
        main()
  '';
in {
  systemd.services.download-sorter = {
    description = "Sorts the Downloads folder daily";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.python3}/bin/python3 ${download-sorter-script}";
      User = "lux";
      WorkingDirectory = "/home/lux";
    };
  };

  systemd.timers.download-sorter = {
    description = "Runs the downloads sorter script at 5 AM or on boot if missed";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "05:00";
      Persistent = true; # Ensures the job runs after boot if it was missed
      AccuracySec = "1m"; # Ensures it runs close to 5 AM
      RandomizedDelaySec = "0"; # Runs exactly at 5 AM without delay
    };
  };
}
