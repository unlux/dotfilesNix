{...}: {
  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp /home/lux/PATH-TO/.face /var/lib/AccountsService/icons/lux
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/lux\n" > /var/lib/AccountsService/users/lux

    chown root:root /var/lib/AccountsService/users/lux
    chmod 0600 /var/lib/AccountsService/users/lux

    chown root:root /var/lib/AccountsService/icons/lux
    chmod 0444 /var/lib/AccountsService/icons/lux
  '';
}
