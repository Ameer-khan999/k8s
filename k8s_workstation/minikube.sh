sudo growpart /dev/nvme0n1 4
sudo lvextend -r -l +100%FREE /dev/RootVG/varVol
curl -sfL https://get.k3s.io | sh -
export USER="ec2-user"
mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER ~/.kube/config
echo "Success"