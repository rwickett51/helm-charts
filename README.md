# Helm Chart Install
This repo contains helm charts to deploy to the local home cluster

## Dry run service
`helm install <service> media/ --dry-run --debug --values /<service>/values.yaml --namespace media`

## Install service
`helm upgrade <service> media/ --values <service>/values.yaml --namespace media`