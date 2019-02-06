workflow "New workflow" {
  on = "push"
  resolves = ["Commit and Push"]
}

action "Package Chart" {
  uses = "dtzar/helm-kubectl@sha256:ce2a9ef4e949467033d06fb91eabf16aaac38d95e2616a083d0144c7a37a9197"
  args = "helm package --save=false -d ${GITHUB_WORKSPACE}/docs/${CHART_STABILITY} ${GITHUB_WORKSPACE}/${CHART_STABILITY}/${CHART_NAME}"
  env = {
    CHART_STABILITY = "incubating"
    CHART_NAME = "control-hub"
  }
}

action "Generate Repo Index" {
  uses = "dtzar/helm-kubectl@sha256:ce2a9ef4e949467033d06fb91eabf16aaac38d95e2616a083d0144c7a37a9197"
  args = "helm repo index ${CHART_STABILITY} --url https://streamsets.github.io/helm-charts/${CHART_STABILITY}"
  env = {
    CHART_STABILITY = "incubating"
  }
  needs = ["Package Chart"]
}

action "Commit and Push" {
  uses = "elstudio/actions-js-build/commit@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    PUSH_BRANCH = "master"
  }
  needs = ["Generate Repo Index"]
}
