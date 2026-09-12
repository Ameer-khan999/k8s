What Gets Left Behind (Potential Billable Resources)
AWS Load Balancers (ALB / NLB):

If you create Kubernetes Service objects of type LoadBalancer or use the AWS Load Balancer Controller (Ingress), AWS provisions an ALB or NLB outside of CloudFormation.

Impact: eksctl will either fail to delete the VPC or leave the Load Balancers active, costing ~$18+/month per load balancer.

Persistent Volumes (EBS / EFS):

If your applications (like RoboShop databases) claim dynamic storage via PersistentVolumeClaim (PVC), AWS provisions independent EBS volumes.

Impact: The storage volumes remain in your AWS EC2 console and incur monthly storage charges.

IAM Roles for Service Accounts (IRSA):

Service-linked IAM roles created manually outside eksctl remain in your account (though these are free).

Safe Cleanup Sequence
Before running eksctl delete cluster, run these two commands to wipe all in-cluster AWS dependencies:

Bash
# 1. Delete all Kubernetes Services to release AWS Load Balancers
kubectl delete svc --all-namespaces --all

# 2. Delete all PVCs to release EBS volumes
kubectl delete pvc --all-namespaces --all
Once those resources finish terminating, run the cluster deletion command:

Bash
eksctl delete cluster -f cluster.yaml
How to Verify Zero Remaining Resources
After the command finishes, check these two areas in the AWS Management Console to confirm nothing is incurring costs:

EC2 Dashboard -> Load Balancers & Target Groups: Ensure 0 active load balancers remain.

EC2 Dashboard -> Elastic Block Store -> Volumes: Ensure no leftover volumes are in the available or in-use state.