使用kubernetes部署hyperledger fabric官方文档中的byfn示例网络

### 1、准备

3台ubuntu 16.04虚机

| hostname   | IP              |
| ---------- | --------------- |
| kube-node1 | 192.168.126.128 |
| kube-node2 | 192.168.126.129 |
| kube-node3 | 192.168.126.130 |

kubernetes集群 v1.16.2

| hostname   | IP              | role   |
| ---------- | --------------- | ------ |
| kube-node1 | 192.168.126.128 | master |
| kube-node2 | 192.168.126.129 | slave  |
| kube-node3 | 192.168.126.130 | slave  |

在3台虚拟机上配置```/etc/hosts```,添加以下内容

```
192.168.126.128 kube-node1
192.168.126.129 kube-node2
192.168.126.130 kube-node3
```

docker 19.03
nfs

关于如何部署k8s集群以及安装docker，本文不做讨论。

### 2、clone git仓库

#### 2.1 clone仓库

```bash
$ cd /home/www/
$ git clone https://github.com/iamlzw/byfn-on-k8s.git
$ cd byfn-on-k8s
$ pwd
##后面将该路径作为nfs的挂载路径
/home/www/byfn-on-k8s
```

#### 2.1 项目目录

```
 byfn-on-k8s   
    ├── byfn-namespace.yaml
    ├── byfn-storage.yaml
    ├── chaincode
    ├── channel-artifacts
    ├── crypto-config #身份材料以及tls材料
    ├── data
    ├── init.sh
    ├── mychannel.block #创世块
    ├── orderer.yaml #排序节点的yaml文件
    ├── peer0-org1.yaml #peer0.org1
    ├── peer0-org2.yaml 
    ├── peer1-org1.yaml
    ├── peer1-org2.yaml
    ├── start.sh
    └── stop.sh
```

*.yaml-byfn的yaml文件

channel-artifacts-创世块，配置交易

chaincode-智能合约

crypto-config-组件的加密材料

*.sh部署/停止/初始化脚本

### 3、安装nfs

#### 3.1 安装nfs服务端

在kube-node1(192.168.126.128)上安装nfs服务端

```bash
$ sudo apt-get update
$ sudo apt-get install -y nfs-kernel-server
```

#### 3.2 配置nfs

```bash
$ sudo vim /etc/exports
##添加以下内容然后保存
/home/www/byfn-on-k8s *(rw,sync,no_root_squash,no_subtree_check)
## 重启服务
$ sudo /etc/init.d/rpcbind restart
$ sudo /etc/init.d/nfs-kernel-server restart
```

#### 3.3 验证nfs

```bash
$ showmount -e 192.168.126.128
```

#### 3.4 在其他服务器挂载nfs

在另外两台虚机(kube-node2,kube-node3)上挂载nfs

```bash
$ sudo apt-get install -y nfs-common
$ sudo mount -t nfs 192.168.126.128:/home/www/byfn-on-k8s /mnt
$ showmount -e 192.168.126.128
## 输出以下内容
/home/www/byfn-on-k8s *
```

![image.png](http://lifegoeson.cn:8888/images/2021/03/22/image.png)

### 4、启动byfn

启动byfn

```bash
$ cd /home/www/byfn-on-k8s
$ sudo chmod +x *.sh
$ ./start.sh
```

![imagee7969227992d46ee.png](http://lifegoeson.cn:8888/images/2021/03/22/imagee7969227992d46ee.png)

查看pod启动情况

```bash
$ kubectl get pods -n byfn
```

![imagef5447a125fbb3ce6.png](http://lifegoeson.cn:8888/images/2021/03/22/imagef5447a125fbb3ce6.png)

这里我们可以看到byfn部署成功。

### 5、安装实例化智能合约

因为没有部署cli容器，而是直接在terminal中执行相关操作，所以需要将chaincode复制到```$GOPATH/src```目录下，同时需要修改```/etc/hosts```,添加以下内容，IP为主节点或者从节点IP都可以。我们在访问peer或者orderer时，请求的domain name应当与peer或者orderer中的服务端证书中的的common name一致，否则会报错，“tls：bad certificates”，具体参考http://lifegoeson.cn/2021/03/14/peer%20channel%20join%20%E6%97%B6%E6%8A%A5%E9%94%99TLS%20handshake%20failed%20with%20error%20remote%20error%20tls%20bad%20certificate%20server=PeerServer%20remoteaddress/
```
192.168.126.128 orderer.example.com
192.168.126.128 peer0.org1.example.com
192.168.126.128 peer1.org1.example.com
192.168.126.128 peer0.org2.example.com
192.168.126.128 peer1.org2.example.com
```
执行初始化脚本
```bash
$ cd /home/www/byfn-on-k8s
$ sudo cp -r chaincode $GOPATH/src
$ ./init.sh
```
这里需要等待一会，因为初始化链码以及invoke会耗费一点时间。
![imagec01ac4f6c80d5129.png](http://lifegoeson.cn:8888/images/2021/03/22/imagec01ac4f6c80d5129.png)

init脚本的内容基本上参考https://hyperledger-fabric.readthedocs.io/en/release-1.4/chaincode4noah.html#installing-chaincode

你也可以参考脚本内容，手动操作。
