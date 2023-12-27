FROM ubuntu:22.04

MAINTAINER root "i@1046.me"

RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends wget proxychains net-tools openssh-server curl vim htop git screen sudo nano ca-certificates rsync zsh tzdata build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf locales automake libtool autopoint device-tree-compiler gperf antlr3 cron \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& locale-gen en_US.UTF-8 \
	&& useradd -m admin \
	&& echo admin:admin | chpasswd \
	&& echo 'admin ALL=NOPASSWD: ALL' > /etc/sudoers.d/admin \
	&& mkdir /var/run/sshd \
	&& cd /home/admin \
	&& git clone git://github.com/robbyrussell/oh-my-zsh ./.oh-my-zsh \
	&& cp /home/admin/.oh-my-zsh/templates/zshrc.zsh-template ./.zshrc \
	&& git clone git://github.com/zsh-users/zsh-syntax-highlighting ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
	&& git clone git://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions \
	&& sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/g' .zshrc \
	&& sed -i 's/plugins=(git)/plugins=(git sudo zsh-syntax-highlighting zsh-autosuggestions)/g' .zshrc \
	&& sed -i 's/# DISABLE_AUTO_UPDATE/DISABLE_AUTO_UPDATE/g' .zshrc \
	&& echo 'export LC_ALL="en_US.UTF-8"' >> .zshrc \
	&& echo 'export LANG="en_US.UTF-8"' >> .zshrc \
	&& chown -R admin:admin /home/admin \
	&& cp -R ./.oh-my-zsh/ /root/ \
	&& cp ./.zshrc /root \
	&& sed -i 's/\/home\/admin:\/bin\/sh/\/home\/admin:\/bin\/zsh/g' /etc/passwd \
	&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& dpkg-reconfigure -f noninteractive tzdata

CMD service cron start
CMD ["sudo", "/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
EXPOSE 22

USER admin
WORKDIR /home/admin
