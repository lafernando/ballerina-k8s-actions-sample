workflow "Build & Deploy" {
  on = "push"
  resolves = ["K8s Deploy"]
}

action "Ballerina Build" {
  uses = "ballerina-platform/github-actions/cli/latest@master"
  args = "build"
  secrets = [
    "docker_username",
    "docker_password",
  ]
}

action "K8s Deploy" {
  uses = "actions/aws/kubectl@master"
  args = "apply -f /github/workspace/kubernetes/"
  secrets = ["KUBE_CONFIG_DATA"]
  needs = ["Ballerina Build"]
}
