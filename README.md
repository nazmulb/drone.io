# Drone CI

## What is CI/CD? 

**Continuous Integration (CI)** - is the practice of merging all developer working copies to a shared mainline several times a day. A complementary practice to CI is that before submitting work, each programmer must do a complete build and run (and pass) all unit tests. Integration tests are usually run automatically on a CI server (Jenkins/Drone/CercleCI) when it detects a new commit.

**Continuous Delivery (CD)** - It aims at building, testing, and releasing software with greater speed and frequency. Delivery team -> Version Control -> Build & unit tests -> Automated acceptance tests (e2e) -> UAT -> Release (Deployment, DevOps) 

<img alt="CI/CD Process" src="https://raw.githubusercontent.com/nazmulb/drone.io/master/images/cicd.png" width="850px" />

## What is Drone?

Drone is a modern CI/CD platform built with a containers-first architecture. It enables you to conveniently set up projects to automatically build, test, and deploy as you make changes to your code. It's open source, highly configurable (every build step is executed by a container!) and has a lot of plugins available. Drone is built using Go and utilizes Docker. It can be run inside a container itself with very little configuration.

Pipelines are configured using a special YAML file that you check-in to your git repository. The syntax is designed to be easy to read and expressive so that anyone using the repository can understand the continuous delivery process.

```
---
kind: pipeline
name: default

steps:
- name: backend
  image: golang
  commands:
  - go build
  - go test

- name: frontend
  image: node
  commands:
  - npm install
  - npm test

...
```