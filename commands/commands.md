  1  gcloud auth login
    2  gcloud auth list
    3  gcloud config list project
    4  gcloud config set compute/zone us-west3-b
    5  ls -ltr
    6  gcloud storage cp -r gs://spls/gsp053/kubernetes .
    7  ls -ltr
    8  cd kubernetes/
    9  ls -ltr
   10  gcloud container clusters create bootcamp --machine-type e2-small --num-nodes 3 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"
   11  kubectl get nodes
   12  kubectl expalin deployments
   13  kubectl explain deployments
   14  kubectl explain deployments --recursive
   15  kubectl explain deployment.metadata.name
   16  ls -ltr
   17  cat deployments/fortune-app-blue.yaml
   18  kubectl create -f deployments/fortune-app-blue.yaml
   19  kubectl get deployments
   20  kubectl get pods
   21  kubectl create -f services/fortune-app.yaml
   22  kubectl get services fortune-app
   23  curl http://34.185.93.132/version
   24  curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
   25  kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip
   26  kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}
   27  cat  services/fortune-app.yaml
   28  kubectl scale deployment fortune-app-blue --replicas=5
   29  kubectl get pods | grep fortune-app-blue | wc -l
   30  kubectl scale deployment fortune-app-blue --replicas=3
   31  kubectl get pods | grep fortune-app-blue | wc -l
   32  kubectl get pods | grep fortune-app-blue
   33  kubectl edit deployment fortune-app-blue
   34  kubectl get replicaset
   35  kubectl edit deployment fortune-app-blue
   36  kubectl get replicaset
   37  kubectl rollout history deployment/fortune-app-blue
   38  kubectl rollout pause deployment/fortune-app-blue
   39  kubectl rollout status deployment/fortune-app-blue
   40  for p in $(kubectl get pods -l app=fortune-app -o=jsonpath='{.items[*].metadata.name}'); do echo $p && curl -s http://$(kubectl get pod $p -o=jsonpath='{.status.podIP}')/version; echo; done
   41  kubectl rollout resume deployment/fortune-app-blue
   42  kubectl rollout status deployment/fortune-app-blue
   43  for p in $(kubectl get pods -l app=fortune-app -o=jsonpath='{.items[*].metadata.name}'); do echo $p && curl -s http://$(kubectl get pod $p -o=jsonpath='{.status.podIP}')/version; echo; done
   44  kubectl rollout undo deployment/fortune-app-blue
   45  curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
   46  cat deployments/fortune-app-canary.yaml
   47  kubectl create -f deployments/fortune-app-canary.yaml
   48  for i in {1..10}; do curl -s http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version; echo; done
   49  kubectl apply -f services/fortune-app-blue-service.yaml
   50  kubectl create -f deployments/fortune-app-green.yaml
   51  curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
   52  kubectl apply -f services/fortune-app-green-service.yaml
   53  curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
   54  kubectl apply -f services/fortune-app-blue-service.yaml
   55  curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version