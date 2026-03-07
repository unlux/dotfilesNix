{pkgs, ...}: let
  download-sorter-script = pkgs.writeScript "download_sorter.py" ''
    #!/usr/bin/env python3
    import os
    import shutil
    import datetime
    import logging

    logging.basicConfig(level=logging.INFO, format="%(message)s")
    log = logging.getLogger("download-sorter")

    DOWNLOADS_DIR = os.path.expanduser("~/Downloads")
    RECENT_DIR = os.path.join(DOWNLOADS_DIR, "Recent")
    ARCHIVE_DIR = os.path.join(DOWNLOADS_DIR, "Archive")

    ALL_FOLDERS = [RECENT_DIR, ARCHIVE_DIR]

    def ensure_dirs():
        for directory in ALL_FOLDERS:
            os.makedirs(directory, exist_ok=True)

    def get_file_age(file_path):
        return datetime.datetime.now() - datetime.datetime.fromtimestamp(os.path.getmtime(file_path))

    def get_target_dir(age):
        if age < datetime.timedelta(days=7):
            return None
        elif age < datetime.timedelta(days=30):
            return RECENT_DIR
        else:
            return ARCHIVE_DIR

    def safe_dest_path(dest_dir, filename):
        dest_path = os.path.join(dest_dir, filename)
        if not os.path.exists(dest_path):
            return dest_path
        name, ext = os.path.splitext(filename)
        counter = 1
        while True:
            new_name = f"{name} ({counter}){ext}"
            dest_path = os.path.join(dest_dir, new_name)
            if not os.path.exists(dest_path):
                return dest_path
            counter += 1

    def move_and_preserve_metadata(src, dest_dir):
        if os.path.dirname(src) == dest_dir:
            return
        original_stat = os.stat(src)
        dest_path = safe_dest_path(dest_dir, os.path.basename(src))
        shutil.move(src, dest_path)
        try:
            os.utime(dest_path, (original_stat.st_atime, original_stat.st_mtime))
        except PermissionError:
            log.warning(f"Could not preserve timestamps for {dest_path}")
        log.info(f"Moved: {os.path.basename(src)} -> {os.path.basename(dest_dir)}/")

    def move_files():
        moved = 0
        for folder in [DOWNLOADS_DIR] + ALL_FOLDERS:
            for item in os.listdir(folder):
                item_path = os.path.join(folder, item)
                if not os.path.isfile(item_path):
                    continue
                age = get_file_age(item_path)
                target = get_target_dir(age)
                if target is None:
                    # < 7 days: belongs in Downloads root
                    if folder != DOWNLOADS_DIR:
                        move_and_preserve_metadata(item_path, DOWNLOADS_DIR)
                        moved += 1
                else:
                    if os.path.dirname(item_path) != target:
                        move_and_preserve_metadata(item_path, target)
                        moved += 1
        log.info(f"Done. {moved} file(s) moved.")

    def main():
        ensure_dirs()
        move_files()

    if __name__ == "__main__":
        main()
  '';
in {
  systemd.services.download-sorter = {
    description = "Sorts the Downloads folder daily";
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
      Persistent = true;
      AccuracySec = "1m";
      RandomizedDelaySec = "0";
    };
  };
}
