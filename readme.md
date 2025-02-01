# README (WIP)

* This project's proposal is to test many GNU common utilities for network diagnosis. It uses Container Images based on Alpine 3.21.2 available at [Docker Hub](https://hub.docker.com/_/alpine/).

* Currently, there are 3 scenarios.

* For execution of a scenario through a bash CLI:
  ```
  scenarioVersion=1
  bash main.sh $scenarioVersion
  ```
  without active firewalls:
  ```
  bash main.sh $scenarioVersion --fw-off
  ```

* For cleanage:
  ```
  bash main.sh $scenarioVersion --clean
  ```
