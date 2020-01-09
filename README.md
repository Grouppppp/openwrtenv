# OpenWrt Environment

**Github**: [https://github.com/10467106/openwrtenv](https://github.com/10467106/openwrtenv)

**Docker Hub**: [https://hub.docker.com/r/10467106/openwrtenv-sshd](https://hub.docker.com/r/10467106/openwrtenv-sshd)

加了 sshd，并修复了大佬原版镜像 ssh 无法连接上的错误，系统编码改为 en_US.utf8，替换源为 Ubuntu cn 官方镜像。

*镜像现已使用 Ubuntu18.04，大佬没改 readme，特此说明。*


##### 这里是与大佬之间的分隔线
---

**Github**: [https://github.com/SuLingGG](https://github.com/SuLingGG)

**Docker Hub**: [https://hub.docker.com/r/sulinggg/openwrtenv](https://hub.docker.com/r/sulinggg/openwrtenv)

## 项目由来

对于初次接触编译或需要经常在多个设备上切换编译的 OpenWrt 编译者而言，编译 OpenWrt 时对编译环境的要求比较高，编译前需要安装的依赖也比较多，配置编译环境就变成一件繁琐而却又不得不做的事情。

Docker 容器具有隔离化，跨平台，易打包，易分发的特点，同时，由于 Docker 官方提供一系列发行版的纯净镜像，以 Docker 官方发布的这些镜像为基础，我们可以搭建起一个 “纯净、隔离”的编译环境。从而简化安装环境的部署，提高编译成功率。

## 项目介绍

此项目灵感来自于 [Lean 大 LEDE 项目](https://github.com/coolsnowwolf/lede)中的编译教程，在官方 [ubuntu:14.04](https://hub.docker.com/_/ubuntu) 镜像的基础上进行了以下添加和修改：

1. 换 ubuntu 官方源为 [清华源](https://mirror.tuna.tsinghua.edu.cn/) 以增加软件包下载和更新速度；

2. 部署了编译 OpenWrt 所需的依赖；

3. 安装 zsh / [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) 以提高命令行输入效率；

4. 为 zsh 添加 [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) / [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) 插件以达到对命令的高亮和补全。

## 使用方法

以下是推荐使用方式：

1. **操作系统**：推荐任意可安装 Docker 的 Linuix 发行版 (暂时没有在 Windows 上测试过)；

2. **磁盘空间**：Docker 安装所在分区剩余 2G 以上，挂载目录所在分区剩余 15G 以上；

3. **其他配置**：越高越好。(毕竟是在跑编译嘛...)

在进行接下来的操作之前请确认你已经正确安装 Docker 并正确配置好加速器，Docker 安装和加速器配置教程可以在 [Docker - 从入门到实践](https://github.com/yeasy/docker_practice) 项目中找到。

1. 在本地建立一个挂载目录，编译过程中产生的所有文件 (包括但不限于源码文件，中间文件，软件包，编译完成后的镜像文件) 都会被存放到这里：

   > mkdir ~/workspace

2. 拉取本项目镜像，使用镜像建立容器：

   > docker run -itd -v ~/workspace:/home/admin/workspace --name openwrtenv sulinggg/openwrtenv

   其中：`~/workspace`为你刚刚在本地建立的挂载路径，`/home/admin/workspace `为容器中的挂载源路径，在容器工作过程中该目录产生的所有文件都将会同步到本地的挂载路径中。

   由于编译过程不能在超级用户 (root)  下进行，所以在镜像中已提前配置好了普通用户 admin，这一步即为将宿主机中的 `~/workspace` 文件夹挂载到容器中用户 admin 家目录下的 `workspace` 文件夹下。

   **特别注意：admin 用户的默认密码同样为 admin。**

3. 进入容器：

   > docker exec -it openwrtenv zsh

   由于在镜像中已经默认部署好 zsh，所以可以直接使用 zsh 作为容器的交互 Shell。
   
4. 更新软件包 (可选)：

   你可以输入 `apt update && apt upgrade -y` 来更新软件包，虽然这一步不是必须操作，不做的话完全没有问题，但是如果有时间的话还是做一下吧~

5. 修复 workspace 文件夹权限：

   chown -R admin:admin /home/admin/workspace

6. 进入容器中的挂载源路径：

   > cd /home/admin/workspace

   切换到刚刚设定好的挂载源路径，在此路径中开始编译工作。

8. 拉取源码开始编译，下面以 Lean 大源码为例：

   > git clone https://github.com/coolsnowwolf/lede
   >
   > cd lede
   >
   > ./scripts/feeds update -a
   >
   > ./scripts/feeds install -a
   >
   > make defconfig
   >
   > make menuconfig
   >
   > make V=99 -j1
   
## 扩展资料

   **详细编译过程请移步:**

   [自编译树莓派 OpenWrt 完全指南 (一) : 环境搭建](https://mlapp.cn/373.html)

   [自编译树莓派 OpenWrt 完全指南 (二) : 参数配置](https://mlapp.cn/374.html)

