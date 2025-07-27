{ config, pkgs, lib, ... }:

let
  # Docker services directory
  dockerServicesDir = pkgs.stdenv.mkDerivation {
    name = "docker-services";
    src = ../docker-global-services;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };

  # Docker Compose service template
  mkDockerComposeService = name: {
    description = "${name} Docker Compose Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "${dockerServicesDir}/${name}";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
    };
  };
in
{
  # Copy docker services to /etc/docker-services/
  environment.etc."docker-services".source = dockerServicesDir;

  # Docker Compose systemd services
  systemd.services = {
    docker-postgres = mkDockerComposeService "postgres";
    docker-mysql = mkDockerComposeService "mysql";
    docker-mssql = mkDockerComposeService "mssql";
    docker-redis = mkDockerComposeService "redis";
    docker-portainer = mkDockerComposeService "portainer";
    docker-rabbitmq = mkDockerComposeService "rabbitmq";
  };
}