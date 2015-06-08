VAGRANT_DEFAULT_PROVIDER=virtualbox
default: all

.PHONY: install
install:
	ansible-playbook -vv -i ansible.ini -l local install.yml

.PHONY: clean
clean:
	rm -rf roles/bbaassssiiee.commoncentos/
	rm -rf roles/bbaassssiiee.artifactory/
	rm -rf roles/bbaassssiiee.sonar/
	rm -rf roles/ansible-ant/
	rm -rf roles/ansible-eclipse/
	rm -rf roles/ansible-maven/
	rm -rf roles/geerlingguy.java/
	rm -rf roles/hudecof.tomcat/
	rm -rf roles/hullufred.nexus/
	rm -rf roles/pcextreme.mariadb/
	rm -rf roles/briancoca.oracle_java7
	rm -rf roles/kbrebanov.*

.PHONY: up
up:
	vagrant halt dev
	vagrant destroy -f dev
	vagrant up --no-provision dev
	wait
	vagrant provision dev

.PHONY: deploy
deploy:
	vagrant halt target
	vagrant destroy -f target
	vagrant up --no-provision target
	vagrant provision target
	ansible-playbook -vv -i ansible.ini -l target deploy.yml


.PHONY: testclient
testclient:
	vagrant halt target
	vagrant halt dev
	vagrant up testclient
	vagrant provision testclient
	vagrant halt testclient

.PHONY: setup
setup:
	vagrant destroy -f target

.PHONY: test
test: clean install setup deploy
	ansible-playbook -vv -i ansible.ini -l target webtest.yml

.PHONY: smoketest
smoketest:
	ansible-playbook -vv -i ansible.ini -l all smoketest.yml

.PHONY: all
all: clean install up setup deploy testclient

.PHONY: babun
babun:
	pact install python python-paramiko python-crypto gcc-g++ wget openssh python-setuptools
	@echo 'export PYTHONHOME=/usr' >> ~/.zshrc
	@echo 'export export PYTHONPATH=/usr/lib/python2.7' >> ~/.zshrc

	export PYTHONHOME=/usr
	export PYTHONPATH=/usr/lib/python2.7
	python /usr/lib/python2.7/site-packages/easy_install.py pip
	pip install ansible
