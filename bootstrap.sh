if [ $(id -u) -eq 0 ]; then
	# remove cdrom from /etc/apt/sources.list
	grep -v cdrom /etc/apt/sources.list>/tmp/sources.list
	cp /tmp/sources.list /etc/apt/sources.list
	# Add Docker's official GPG key:
	apt-get update
	apt-get install ca-certificates curl ansible
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
	      tee /etc/apt/sources.list.d/docker.list > /dev/null
	apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	systemctl start docker
else
	echo "This needs to be run as root. You can get root by running sudo su -"
fi
