workflow "Build & Deploy" {
  on = "push"
  resolves = ["actions/aws/kubectl@master"]
}

action "ballerina-platform/github-actions/cli/latest@master" {
  uses = "lafernando/github-actions/cli/latest@master"
  args = "build"
  secrets = ["docker_username", "docker_password"]
}

action "actions/aws/kubectl@master" {
  uses = "actions/aws/kubectl@master"
  needs = ["ballerina-platform/github-actions/cli/latest@master"]
  secrets = ["KUBE_CONFIG_DATA"]
  args = "apply -f /github/workspace/kubernetes/"
}
