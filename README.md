# mk8s
> A microk8s SpringBoot application on Raspberry Pi

## pre-requirements
* Raspberry Pi with Ubuntu Server 2022.04.4 LTS (64-bit)
* Docker Hub account

## setup Raspberry Pi
* connect to Raspberry Pi (ssh)
* update linux packages
  ```shell
  sudo apt-get update
  sudo apt-get upgrade
  sudo reboot
  ```
* install java 17 and maven
  ```shell
  sudo apt install openjdk-17-jre-headless
  sudo apt install maven
  ```
* install docker
  * https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
* add current user to the docker group
  ```shell
  sudo usermod -a -G docker $USER
  su - $USER
  ```
* install microk8s
  * https://microk8s.io/docs/getting-started
* enable MetalLB addon for microk8s
  ```shell
  microk8s enable metallb
  ```
* install other packages
  ```shell
  sudo snap install yq
  ```

## install SpringBootServer
1. go to mk8s/SpringBootServer directory
2. build maven project
    ```shell
    mvn clean install
    ```
3. go to mk8s/scripts directory
4. update *settings.sh* with your settings
5. add executable permissions to scripts
    ```shell
    chmod +x *.sh
    ```
6. build and push docker image to remote repository
    ```shell
    ./build-and-push-image.sh
    ```
7. install helm chart
    ```shell
    ./helm-install.sh
    ```
8. (if needed) uninstall helm chart
    ```shell
    ./helm-uninstall.sh
    ```

## verify SpringBootServer
1. get <external_ip> address
    ```shell
    microk8s kubectl -n helm-server get service helm-server-load-balancer -o yaml | \
    yq .status.loadBalancer.ingress[0].ip
    ```
2. verify http connection
    ```shell
    curl -k http://<external_ip>/test
    ```

## enable TLS
1. add TLS host to /etc/hosts file
    ```shell
    echo "127.0.0.1 my-tls.example.com" | sudo tee -a /etc/hosts
    ```
2. open port 443
    ```shell
    sudo iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT
    ```
3. go to mk8s/scripts directory
4. run script
    ```shell
    ./enable-tls.sh
    ```
5. verify https connection
    ```shell
    curl https://my-tls.example.com/test
    ```
