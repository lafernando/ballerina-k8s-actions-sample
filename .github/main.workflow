workflow "Build & Deploy" {
  resolves = ["actions/aws/kubectl@master"]
  on = "push"
}

action "Ballerina Build" {
  uses = "ballerina-platform/github-actions/cli/latest@master"
  args = "build"
  secrets = ["docker_username", "docker_password"]
}

action "actions/aws/kubectl@master" {
  uses = "actions/aws/kubectl@master"
  needs = ["Ballerina Build"]
  args = "apply -f /github/workspace/kubernetes/"
  secrets = ["KUBE_CONFIG_DATA"]
}
