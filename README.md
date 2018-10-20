# ShadowsocksR Bootstrap Script
Simple shell script to start client or server ShadowsocksR docker containers. Based on a [Python docker image](https://hub.docker.com/_/python/) and [Python port of ShadowsocksR](https://github.com/shadowsocksrr/shadowsocksr/).
## Get Started
### Dependencies
Requires Docker, Git. See [Docker's documentation](https://docs.docker.com/install/) for installation instructions. 
### Installation
Install the entry point script into your desired location.
```sh
mkdir -p /root/docker/shadowsocksr
wget -O /root/docker/shadowsocksr/entry-point.sh https://raw.githubusercontent.com/dy2k/shadowsocksr-docker/master/entry-point.sh
```
### Configuration
Create a client or server configuration file to be mounted by the container using volume flags.
#### Client
Sample client.json at your desired location with your desired name. You may also configure your own proxy address and port.
```javascript
{
    "server":"<your destination ip>",
    "server_port":"<your destination port>",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"<your destination password>",
    "timeout":120,
    "method":"<your method>",
    "protocol":"<your protocol>",
    "protocol_param":"",
    "obfs":"<your obfs>",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":false,
    "workers":1
}
```
#### Server
Sample server.json at your desired location with your desired name. If you would like to server multiple ports, you may configure using __port_password__ instead of __local_port__ and __port_password__.
```javascript
{
    "server":"0.0.0.0",
    "server_port":"<your server port>",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"<your server password>",
    "port_password":{
        ...,
        "<your server port>":"<your server password>",
    },
    "timeout":120,
    "method":"<your method>",
    "protocol":"<your protocol>",
    "protocol_param":"",
    "obfs":"<your obfs>",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":false,
    "workers":1
}
```
### Usage
Run the entry point script in a docker container. Host networking only works on Linux hosts. If working on other operating systems, please expose ports for services.
#### Entry Point
```
Usage: entry-point.sh <client|server>
```
#### Client
Run an always restart docker container (auto-start on boot when docker service is enabled) using __python:alpine__ image to execute the entry point command with the configuration file and bootstrap script mounted. Host networking for binding ports to host is used. Named as __shadowsocksr-client__.
```sh
docker run --name=shadowsocksr-client --restart=always --network=host --detach --volume /root/docker/shadowsocksr/client.json:/etc/shadowsocksr/config.json --volume /root/docker/shadowsocksr/entry-point.sh:/etc/shadowsocksr/entry-point.sh python:alpine /bin/sh -c "/etc/shadowsocksr/entry-point.sh client"
```
#### Server
Similar to client usage but supplied another configuration file and bootstrap command mode. Named as __shadowsocksr-server__.
```sh
docker run --name=shadowsocksr-server --restart=always --network=host --detach --volume /root/docker/shadowsocksr/server.json:/etc/shadowsocksr/config.json --volume /root/docker/shadowsocksr/entry-point.sh:/etc/shadowsocksr/entry-point.sh python:alpine /bin/sh -c "/etc/shadowsocksr/entry-point.sh server"
```

#### Proxy Configuration
Connect to your server by setting socks5 proxy address for Git:
```sh
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080
```
