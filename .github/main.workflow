workflow "Build & Deploy" {
  on = "push"
  resolves = ["actions/aws/kubectl@master"]
}

action "ballerina-platform/github-actions/cli/latest@master" {
  uses = "ballerina-platform/github-actions/cli/latest@master"
  args = "build"
  secrets = [
    "docker_username",
    "docker_password",
  ]
}

action "actions/aws/kubectl@master" {
  uses = "actions/aws/kubectl@master"
  needs = ["ballerina-platform/github-actions/cli/latest@master"]
  args = "apply -f /github/workspace/kubernetes/"
  secrets = ["KUBE_CONFIG_DATA"]
}
