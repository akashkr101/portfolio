# This file will install all the prerequsit for Jenkins and docker deployment
All Prerequsits :
1. 





echo "step 1"
echo "updating system"
echo ==========
sleep 10s
sudo yum update

echo "step 2"
echo "jenkins repp check"
echo ==========
sleep 10s
ls -l /etc/yum.repos.d/jenkins.repo

echo "step 3"
echo "downloading jenkins repo"
echo ==========
sleep 10s
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

echo "step 4"
echo "downloading jenkins key"
echo ==========
sleep 10s
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

echo "step 5"
echo "checking repo file"
echo ==========
sleep 10s
cat /etc/yum.repos.d/jenkins.repo

echo "step 6"
echo "giving execute permission"
echo ==========
sleep 10s
sudo chmod 644 /etc/yum.repos.d/jenkins.repo

echo "step 7"
echo "updating system"
echo ==========
sleep 10s
sudo yum update

echo "step 8"
echo "Installing java"
echo ==========
sleep 10s
sudo dnf install java-17-amazon-corretto -y
sudo java --version

echo "step 9"
echo "Installing jenkins"
echo ==========
sleep 10s
#sudo yum install jenkins -y
sudo yum install jenkins --nogpgcheck -y

echo "step 10"
echo "enableling jenkins"
echo ==========
sleep 10s
sudo systemctl enable jenkins

echo "step 11"
echo "starting jenkins"
echo ==========
sleep 10s
sudo systemctl start jenkins

echo "step 12"
echo "checking status for Jenkins"
echo ==========
sleep 10s
sudo systemctl status jenkins

echo "step 13"
echo "updating system and installing git"
echo ==========
sleep 10s
sudo yum update -y
sudo yum install git -y
git — version

echo "step 14"
echo "Installing Node"
echo ==========
sleep 10s
sudo yum install nodejs -y
node — version

echo "step 15"
echo "Installing Docker"
echo ==========
sleep 10s
sudo yum update -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo sed -i 's/\$releasever/7/g' /etc/yum.repos.d/docker-ce.repo
sudo yum install docker
sudo yum clean all
sudo rm -rf /var/cache/yum
sudo yum install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo docker run hello-world
sudo yum install -y yum-utils
sudo usermod -aG docker jenkins