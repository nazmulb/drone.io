# Drone CI

## What is CI/CD? 

**Continuous Integration (CI)** - is the practice of merging all developer working copies to a shared mainline several times a day. A complementary practice to CI is that before submitting work, each programmer must do a complete build and run (and pass) all unit tests. Integration tests are usually run automatically on a CI server (Jenkins/Drone/CercleCI) when it detects a new commit.

**Continuous Delivery (CD)** - It aims at building, testing, and releasing software with greater speed and frequency. Delivery team -> Version Control -> Build & unit tests -> Automated acceptance tests (e2e) -> UAT -> Release (Deployment, DevOps) 

<img alt="CI/CD Process" src="https://raw.githubusercontent.com/nazmulb/drone.io/master/images/cicd.png" width="850px" />

## What is Drone?

Drone is a modern CI/CD platform built with a containers-first architecture. It enables you to conveniently set up projects to automatically build, test, and deploy as you make changes to your code. It's open source, highly configurable (every build step is executed by a container!) and has a lot of <a href="http://plugins.drone.io/">plugins</a> available. Drone is built using Go and utilizes Docker. It can be run inside a container itself with very little configuration.

Pipelines are configured using a special <a href="https://docs.drone.io/user-guide/pipeline/steps/">YAML file</a> that you check-in to your git repository. The syntax is designed to be easy to read and expressive so that anyone using the repository can understand the continuous delivery process.

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

## How Drone works?

Drone consists of two main parts: <a href="https://docs.drone.io/installation/github/single-machine/">Server</a>, and <a href="https://docs.drone.io/administration/agents/">Agent(s)</a>. For single server/machine you just need drone server to do all the works for you. If you are running Drone in multi-server mode you will need to install one or more agents. 

Drone Server is a master part, a central piece which serves user interface and exposes API. An agent (worker part) is a small daemon that is installed on a server instance, and it pulls jobs from Drone Server, executes them and pushes the results back. You can scale the system by adding more agents, so it can handle more jobs.

Interesting to notice, Drone Agent only runs a single job at the time. So, if you want to run multiple jobs simultaneously you should set up more than one agent. This approach helps to keep things simple and improve fault tolerance. For example, if an agent fails it only affects a single job.

Another interesting thing to know, Drone Agent is completely stateless. It’s designed to be able to fetch everything it needs for a build from somewhere else: docker registry, git repository, remote storage etc. It means spinning up a new agent is very fast and does not require any special provisioning or preparation.

There is also <a href="https://docs.drone.io/cli/install/">drone-cli</a>, it provides command line interface to Drone Server API, as well as some other useful commands.

### Build Process:

The idea behind Drone’s build process is very simple, but yet incredibly flexible. Every step in the build runs inside a container, which uses an image (<a href="http://plugins.drone.io/">plugins</a>) with tools required to execute the step. These containers share a workspace volume, so things you build in one step are available in the next.

For example, a typical pipeline for Go project would be:

- Create git container, execute git clone to checkout source code to the workspace.
- Create golang container, execute go test and go build to run tests and build executable.
- Create docker container, execute docker build and docker push to build docker image.
- Create kubectl container, execute kubectl apply to deploy the project to the kubernetes cluster.

You are free to use any docker image in build steps, including 3rd party docker registries. Anything you can put in the container can be used during a build. You can use existing applications or write your own.

Important to mention, there is no shared storage between builds, workspace destroyed after the build is complete, containers for steps are destroyed after each step. Instead, if you want to share some files between builds, you can use remote storage (eq. Google Cloud Storage or AWS S3) and additional steps in your pipeline to fetch or push data.