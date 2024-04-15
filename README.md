<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">CRUD Operations</h3>

  <p align="center">
    A simple website capable of getting hosted in kubernetes and monitoring using Prometheus and Grafana
    <br />
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Pre Requisites</a></li>
        <li><a href="#local-deployment">Local Deployment</a></li>
        <li><a href="#load-testing">Load Testing</a></li>
        <li><a href="#cleanup">Cleanup</a></li>
      </ul>
    </li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

### UseCase: Student management system

Website Capabilities:
* Add students to the class
* Update student details
* Remove students from the class

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* ReactJS
* Bootstrap
* ExpressJS
* Mysql

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Pre Requisites

#### Tools to be installed:

* docker
* Local Kubernetes cluster (kind / minikube or relevant)  
* kubectl
* make

#### Directory Structure:

* `kubernetes-manifests/`: root folder for all the kubernetes objects created for website setup
    * `frontend/`: manifests for frontend app
    * `mysql/`: manifests for mysql setup
    * `backend/`: manifests for backend app
    * `prometheus/`: manifests for prometheus setup:
        * `kube-state-metrics/`: manifests for enabling kube-state-metrics in prometheus
    * `grafana/`: manifests for grafana setup
* `init.sql`: consists of SQL queries for initialising MySQL
* `Makefile`: make users life easy by using simple commands to deploy website
* `images/`: contains images used for README.md

### Local Deployment

#### 1. Move inside the folder
```sh
   cd crud-k8s-deploy
```

#### 2. Deploy backend manifests
```sh
  ## deploy mysql manifests
  kubectl apply -f "kubernetes-manifests/mysql/*.yaml"

  ## mysql initialisation
  kubectl exec -i `kubectl get pod | grep mysql | awk '{print $1}'` -- mysql -h localhost \
-u root --password=`kubectl get secret mysql-root-password -o jsonpath='{.data.secretKey}' | base64 -d` < init.sql

  ## deploy backend manifests
  kubectl apply -f "kubernetes-manifests/backend/*.yaml"
```

  (optional)
  to make it simple we can also use the below command to deploy backend setup all at once
  ```sh
  make deploy_backend_app
  ```

#### 3. Deploy frontend manifests
```sh
   ## deploy backend manifests
   kubectl apply -f "kubernetes-manifests/frontend/*.yaml"
```

  (optional)
   make command for deploying frontend manifests
   ```sh
   make deploy_frontend_app
   ```

#### 4. Deploy monitoring manifests
```sh
  ## deploy prometheus manifests
  kubectl apply -f "kubernetes-manifests/prometheus/*.yaml"

  ## enable kube-state-metrics
  kubectl apply -f "kubernetes-manifests/prometheus/kube-state-metrics/*.yaml"

  ## deploy grafana manifests
  kubectl apply -f "kubernetes-manifests/grafana/*.yaml"
```

(optional) 
make command for deploying monitoring manifests
```sh
  make enable_monitoring
```

#### 5. (optional) To deploy application all at once (skip all the above steps)
```sh
  make deploy_complete_stack_local
```

#### 6. Access Endpoints:
```sh
  ## get Node IP. Replace node_name with correct node name. Eg: node01
  kubectl get node -o wide | grep node_name | awk '{print $6}'
```

  Website can be accessed by: http://node_ip:30011

  Prometheus can be accessed by: http://node_ip:30000

  Grafana can be accessed by: http://node_ip:32000

### Load Testing

1. Backend Application is configured with Horizontal Pod Autoscaler with CPU utilization of 50% and replica max limits to 10

2. Run a pod to flood backend service with requests
```sh
  kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://backend:3000; done"
```

3. open a new terminal and check hpa status
```sh
  kubectl get hpa backend-hpa --watch
```

4. We can see the pods getting scaled once CPU hits 50% usage

### Cleanup

#### 1. Delete frontend components
```sh
  kubectl delete -f "kubernetes-manifests/frontend/*.yaml"
```

(optional) use make
```sh
  make delete_frontend_app
```

#### 2. Delete backend components
```sh
  kubectl delete -f "kubernetes-manifests/mysql/*.yaml"
  kubectl delete -f "kubernetes-manifests/backend/*.yaml"
```

(optional) use make
```sh
  make delete_backend_app
```

#### 3. Delete monitoring components
```sh
  kubectl delete -f "kubernetes-manifests/prometheus/*.yaml"

  kubectl delete -f "kubernetes-manifests/prometheus/kube-state-metrics/*.yaml"
  
  kubectl delete -f "kubernetes-manifests/grafana/*.yaml"
```

(optional) use make
```sh
  make disable_monitoring
```

#### 4. (optional) complete cleanup (skip all the above steps)
```sh
  make delete_complete_stack_local
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[product-screenshot]: images/app.png
[React-url]: https://reactjs.org/
[Bootstrap-url]: https://getbootstrap.com
[Express-url]: https://expressjs.com/
[Node-url]: https://nodejs.org/en/
[mysql-url]: https://www.mysql.com/
