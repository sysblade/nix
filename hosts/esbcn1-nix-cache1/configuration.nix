{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/server/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "esbcn1-nix-cache1";
  time.timeZone = "Europe/Madrid";

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    email = "acme@kedare.net";
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedZstdSettings = true;

    appendHttpConfig = ''
      proxy_cache_path /var/cache/nginx/nix levels=1:2 keys_zone=nix:100m max_size=10g inactive=365d use_temp_path=off;

      # Cache only success status codes; in particular we don't want to cache 404s.
      # See https://serverfault.com/a/690258/128321
      map $status $cache_header {
        200     "public";
        302     "public";
        default "no-cache";
      }

      log_format cache_log '$remote_addr - $remote_user [$time_local] "$request" $status $upstream_cache_status $body_bytes_sent  "$http_referer" "$http_user_agent"'; 

      access_log /var/log/nginx/access.log cache_log;
    '';

    virtualHosts."cache.nix.keda.re" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "$upstream_endpoint";
        extraConfig = ''
          proxy_cache nix;
          proxy_cache_valid  200 302  60d;
          expires max;
          add_header Cache-Control $cache_header always;
          add_header X-Cache-Status $upstream_cache_status always;
          proxy_ssl_server_name on;
        '';
      };

      extraConfig = ''
        # Using a variable for the upstream endpoint to ensure that it is
        # resolved at runtime as opposed to once when the config file is loaded
        # and then cached forever (we don't want that):
        # see https://tenzer.dk/nginx-with-dynamic-upstreams/
        # This fixes errors like
        #   nginx: [emerg] host not found in upstream "upstream.example.com"
        # when the upstream host is not reachable for a short time when
        # nginx is started.
        resolver 8.8.8.8;
        set $upstream_endpoint https://cache.nixos.org;
      '';

      # We always want to copy cache.nixos.org's nix-cache-info file,
      # and ignore our own, because `nix-push` by default generates one
      # without `Priority` field, and thus that file by default has priority
      # 50 (compared to cache.nixos.org's `Priority: 40`), which will make
      # download clients prefer `cache.nixos.org` over our binary cache.
      locations."= /nix-cache-info" = {
        # Note: This is duplicated with the `@fallback` above,
        # would be nicer if we could redirect to the @fallback instead.
        proxyPass = "$upstream_endpoint";
        extraConfig = ''
          proxy_cache nix;
          proxy_cache_valid  200 302  60d;
          expires max;
          add_header Cache-Control $cache_header always;
        '';
      };
    };
  };
}
