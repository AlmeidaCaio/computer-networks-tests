# README (WIP)

* This project's proposal is to test many GNU common utilities for network diagnosis. 

* Currently, there are only 2 scenarios.

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
