{ config, pkgs, lib, ... }:

let
  # Визначаємо директорію docker-global-services як пакет у Nix Store
  dockerServicesDir = pkgs.stdenv.mkDerivation {
    name = "docker-services";
    src = ../docker-global-services;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };

  # Функція для створення Docker Compose сервісу
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
  # Копіюємо docker-global-services до /etc/docker-services/
  environment.etc."docker-services".source = dockerServicesDir;

  # Створюємо systemd служби для кожного Docker Compose сервісу
  systemd.services = {
    docker-postgres = mkDockerComposeService "postgres";
    docker-mysql = mkDockerComposeService "mysql";
    docker-mssql = mkDockerComposeService "mssql";
    docker-redis = mkDockerComposeService "redis";
    docker-portainer = mkDockerComposeService "portainer";
    docker-rabbitmq = mkDockerComposeService "rabbitmq";
  };
}