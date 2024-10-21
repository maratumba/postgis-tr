build:
  docker build -t maratumba/postgis-tr:3.5.0 -t maratumba/postgis-tr:latest .

push:
  docker push maratumba/postgis-tr:3.5.0
  docker push maratumba/postgis-tr:latest