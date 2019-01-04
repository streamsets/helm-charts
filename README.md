# StreamSets Helm Chart Repository

This is the official source repository for Helm Charts maintained by StreamSets, Inc. There are two available chart repositories:

* streamsets-stable
* streamsets-incubating

Stable Charts meet the criteria in the technical requirements.

Incubator Charts are those that do not meet these criteria. Having the incubator folder allows charts to be shared and improved on until they are ready to be moved into the stable folder.

## Adding the repositories

`helm repo add streamsets https://streamsets.github.io/helm-charts/stable`
`helm repo add streamsets-incubating https://streamsets.github.io/helm-charts/incubating`

## Technical requirements

* Must pass the linter (ct lint)
* Must successfully launch with default values (helm install .)
  * All pods go to the running state (or NOTES.txt provides further instructions if a required value is missing.
* Images should not have any major security vulnerabilities
* Should follow Kubernetes best practices
  * Include Health Checks wherever practical
  * Allow configurable resource requests and limits
* Provide a method for data persistence (if applicable)
* Support application upgrades
* Allow customization of the application configuration
* Provide a secure default configuration
* Do not leverage alpha features of Kubernetes
* Includes a NOTES.txt explaining how to use the application after install
* Follows best practices (especially for labels and values)
