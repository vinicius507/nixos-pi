{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    dataDir = "/mnt/storage/data/postgresql";
    settings = {
      fsync = "off";
      synchronous_commit = "off";
      full_page_writes = "off";
      shared_buffers = "128 MB";
      work_mem = "4 MB";
      maintenance_work_mem = "64 MB";
    };
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
      host all all 100.64.0.0/10 trust
    '';
    identMap = ''
      superuser_map      root      postgres
      superuser_map      postgres  postgres
      superuser_map      /^(.*)$   \1
    '';
  };
  systemd.services.postgresql = {
    after = ["mnt-storage.mount"];
  };
}
