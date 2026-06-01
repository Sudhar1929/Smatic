# Node.js API - EKS Deployment

## Career Objective

Deploy production grade applications on cloud infrastructure using DevOps practices and tools like Kubernetes, Jenkins and AWS.

---
## Folder Structure

```
.
├── Dockerfile
├── Jenkinsfile
├── README.md
├── kubernetes/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingres.yaml
└── monitoring/
    ├── prometheus.yaml
    └── logstash-pipeline.conf
```
---

## Stack Used

- AWS EKS for kubernetes cluster
- Jenkins for CI/CD
- Prometheus and Grafana for monitoring
- ELK stack for logging
- Artifactory for storing docker images

---

## Dockerfile

Original dockerfile had some issues like using node:latest and running as root. Changed it to use node:20-alpine with a multi stage build and added a non root user and health check.

---

## Kubernetes

Using 3 manifest files - deployment, service and ingress. Container port is named api-web. App runs with 2 replicas and uses rolling update so no downtime during deployments.

---

## CI/CD

Jenkins pipeline builds the docker image, runs tests and pushes to Artifactory using docker-creds credentials. Then deploys to EKS using kubectl.

---

## Monitoring

Prometheus scrapes metrics from the app. Alerts configured for high error rate and slow response time. Logstash collects logs and sends to Elasticsearch.

---

## Assumptions

- App has /health and /metrics endpoints
- ALB ingress controller is installed in the cluster
- jarvis-artifactory credential is already saved in Jenkins
