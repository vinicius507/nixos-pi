{
  pkgs,
  lib,
  ...
}: {
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnWlEG28kCC02oYW/dIKq/BJ6bFDRwGk65Ph5UhH7Pd root@coolify"
  ];
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  systemd.services.coolify-prepare-files = {
    description = "Setup files for coolify";
    after = ["mnt-storage.mount"];
    wantedBy = ["coolify.service"];
    script = ''
      #! ${pkgs.bash}/bin/bash
      NAMES='source ssh applications databases backups services proxy webhooks-during-maintenance ssh/keys ssh/mux proxy/dynamic'
      for NAME in $NAMES
      do
        FOLDER_PATH="/mnt/storage/data/coolify/$NAME"
        if [ ! -d "$FOLDER_PATH" ]; then
          mkdir -p "$FOLDER_PATH"
        fi
      done

      if [ ! -f "/mnt/storage/data/coolify/source/docker-compose.yml" ]; then
        ${pkgs.curl}/bin/curl -fsSL https://cdn.coollabs.io/coolify/docker-compose.yml -o /mnt/storage/data/coolify/source/docker-compose.yml
        ${pkgs.curl}/bin/curl -fsSL https://cdn.coollabs.io/coolify/docker-compose.prod.yml -o /mnt/storage/data/coolify/source/docker-compose.prod.yml
        ${pkgs.curl}/bin/curl -fsSL https://cdn.coollabs.io/coolify/.env.production -o /mnt/storage/data/coolify/source/.env
        ${pkgs.curl}/bin/curl -fsSL https://cdn.coollabs.io/coolify/upgrade.sh -o /mnt/storage/data/coolify/source/upgrade.sh
      fi

      chown -R 9999:root /mnt/storage/data/coolify
      chmod -R 700 /mnt/storage/data/coolify

      if ! grep -q DONE=true /mnt/storage/data/coolify/source/.env ; then
        sed -i "s|APP_ID=.*|APP_ID=$(${pkgs.openssl}/bin/openssl rand -hex 16)|g" /mnt/storage/data/coolify/source/.env
        sed -i "s|APP_KEY=.*|APP_KEY=base64:$(${pkgs.openssl}/bin/openssl rand -base64 32)|g" /mnt/storage/data/coolify/source/.env
        sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=$(${pkgs.openssl}/bin/openssl rand -base64 32)|g" /mnt/storage/data/coolify/source/.env
        sed -i "s|REDIS_PASSWORD=.*|REDIS_PASSWORD=$(${pkgs.openssl}/bin/openssl rand -base64 32)|g" /mnt/storage/data/coolify/source/.env
        sed -i "s|PUSHER_APP_ID=.*|PUSHER_APP_ID=$(${pkgs.openssl}/bin/openssl rand -hex 32)|g" /mnt/storage/data/coolify/source/.env
        sed -i "s|PUSHER_APP_KEY=.*|PUSHER_APP_KEY=$(${pkgs.openssl}/bin/openssl rand -hex 32)|g" /mnt/storage/data/coolify/source/.env
        sed -i "s|PUSHER_APP_SECRET=.*|PUSHER_APP_SECRET=$(${pkgs.openssl}/bin/openssl rand -hex 32)|g" /mnt/storage/data/coolify/source/.env
        echo "DONE=true" >> /mnt/storage/data/coolify/source/.env
      fi
    '';
  };
  systemd.services.coolify = {
    script = ''
      if ! ${pkgs.docker}/bin/docker network inspect coolify &> /dev/null; then
        ${pkgs.docker}/bin/docker network create --attachable coolify
      fi
      ${pkgs.docker}/bin/docker compose \
        --env-file /mnt/storage/data/coolify/source/.env \
        -f /mnt/storage/data/coolify/source/docker-compose.yml \
        -f /mnt/storage/data/coolify/source/docker-compose.prod.yml \
        up --pull always --remove-orphans --force-recreate
    '';
    environment = {
      APP_PORT = "8001";
    };
    after = [
      "docker.service"
      "docker.socket"
      "mnt-storage.mount"
    ];
    wantedBy = ["multi-user.target"];
  };
}
