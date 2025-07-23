#!/bin/bash
SERVICES=("postgres" "mysql" "mssql" "redis" "portainer" "rabbitmq")

case $1 in
  start)
    for service in "${SERVICES[@]}"; do
      cd ~/docker-services/$service
      docker-compose up -d
    done
    ;;
  stop)
    for service in "${SERVICES[@]}"; do
      cd ~/docker-services/$service
      docker-compose down
    done
    ;;
  status)
    docker ps
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
    ;;
esac
