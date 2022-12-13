# DevOps Interview Tasks by aiMotive
This repository contains everything (except the [monitoring](https://github.com/madacsbotond/aimotive#monitoring)).
## Requirements
To deploy the services, applications and monitoring you have these to install these:
- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- [docker](https://docs.docker.com/get-docker/)
- [terraform](https://developer.hashicorp.com/terraform/downloads)
- [python](https://www.python.org/downloads/) (for testing)
## Docker image
Docker is used to create the Flask application's image. I used a lightweight **python:3.11-alpine** and installed *curl* (for testing), *git* (for getting version hash), *flask* and *redis*. The built docker image is available at [madacsbotondpal/flaskapp:1.0](https://hub.docker.com/r/madacsbotondpal/flaskapp)
## Flask
Flask is used to create the web application. [More about flask.](https://flask.palletsprojects.com/en/2.2.x/)
## Kubernetes
A Kubernetes cluster was used to deploy the resources. Minikube is a small and lightweight Kubernetes implementation. 
## Terraform
To create the deployment (except the monitoring) at the click of a button terraform was used. The resources that belong together are gathered together, making it easy to make any changes.
## Redis
Redis is used to persistently store the alarm counters data, with the help of *PersistentVolume* and *PersistentVolumeClaim*. 
## Monitoring
For monitoring an external repository was used, [Kube-Prometheus](https://github.com/prometheus-operator/kube-prometheus), which contains Prometheus, Grafana and Alertmanager deployment as well. The created dashboard and alertrule are available at the [monitoring](kubernetes_files/monitoring) directory.
## Results
Once all resources are started, curl can be used to test access to the endpoints of the Flask application. Inside Grafana you can see how many non-system pods are running, if too many alarms are received by the Flask application. Pictures can be found in the [pictures](results) directory.
## Quickstart
- Make sure *minikube*, *docker*, *git* and *terraform* are available at the host. 
- Run `terraform init` and `terraform apply` at [terraform](terraform) directory. 
- To run monitoring follow  [these instructions](https://github.com/prometheus-operator/kube-prometheus#quickstart). 
- To access the running services use `minikube service $service-name -n $namespace-name --url`
- Use `kubectl apply -f ./kubernetes_files/monitoring/prometheus_alertrule.yaml` to apply alertrule
- Log in to Grafana and apply *dashboard.json* to see the number of the running non-system pods and create a contant point and notification policy to send alerts to the Flask application.
- Test the running application. 
## Softwares
Used software versions:
- minikube v1.27.1
- kubernetes v1.23 
- terraform v1.2.7
- docker engine v20.10.17
- macOS Monterey V12.6
