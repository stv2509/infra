[![Build Status](https://travis-ci.com/stv2509/infra.svg?branch=master)](https://travis-ci.com/stv2509/infra)


# Homework 3. Practice working with Git and Github

## В процессе сделано:

 <details>
  <summary>Настроен Config git global: </summary>

```bash
git config --global user.name "Dmitriy Sobolev"
git config --global user.email "stv2509@gmail.com"
git config --global alias.hist "log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(red)%s %C(bold red){{%an}}%C(reset) %C(blue)%d%C(reset)' --graph --date=short"
git config --global alias.l "log --all --decorate --oneline --graph"
git config --global core.autocrlf "input"
git config --global core.editor "vim"
git config --global merge.tool "vimdiff"
git config --global credential.helper "cache --timeout=3600"
```
</details>


  <details>
  <summary>Изменен config ~/.bashrc для удобства работы с git: </summary>

```bash

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="\033[00;32;1m\u@\h \033[00m\]\033[00;33;1m\W \033[00m\]\[\033[00;36;1m\]\$(git_branch)\[\033[00m\]\\n$ "
```
</details>

#
# Homework 5. Introduction Cloud Infrastructure. Google Cloud Platform

## В процессе сделано:

 - Создана учетная запись в GCP
 - Создан проект infra
 - В проекте infra созданы instances "bastion" и "someinternalhost"

### Как запустить проект:
<details>
  <summary>Подключение к instances по SSH:</summary>

# 
- Чтобы попасть с "bastion" в "someinternalhost" по ssh через internal ip, настроим SSH Forwarding на вашей локальной машине:
```bash
$ ssh-add -L
The agent has no identities.
```
если получили ошибку:
```bash
$ ssh-add -L
Could not open a connection to your authentication agent.
```
выполните команду
```bash
ssh-agent bash
```
добавим приватный ключ в ssh агент авторизации:
```bash
$ ssh-add ~/.ssh/appuser
Identity added: /home/vagrant/.ssh/appuser (appuser)
```
добавим в параметры подключения ключик -A, чтобы явно включить SSH Agent Forwarding:
```bash
 $ ssh -i ~/.ssh/appuser -A appuser@146.148.80.202
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.10.0-32-generic x86_64)
```
#
- подключение к someinternalhost в одну строку:
```bash
$ ssh -i ~/.ssh/appuser -A -J appuser@ext_ip_bastion appuser@int_ip_someinternalhost
```
#
- для подключения по алиасу someinternalhost в файл ~/.ssh/config добавить следующие строки:
```bash
$ cat ~/.ssh/config

IdentityFile ~/.ssh/appuser
Host someinternalhost
        HostName $int_ip_someinternalhost
        USER appuser
        ProxyJump appuser@$ext_ip_bastion
```
bastion_IP = 35.198.167.169

someinternalhost_IP = 10.156.0.3
</details>


<details>
  <summary>Создаем VPN-сервер для серверов GCP:</summary>

#
- Установка *Pritunl (многофунциональная оболочка управления VPN-сервером)* :
```bash
appuser@bastion:~$
cat <<EOF> setupvpn.sh
#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
EOF

appuser@bastion:~$ sudo bash setupvpn.sh
```

- Открываем в браузере ссылку: [https://<адрес bastionVM>/setup](https://cloud.google.com)

- [Создаем организацию и пользователя](https://docs.pritunl.com/v1/docs/connecting)

- На вкладке *Users*  справа от имени пользователя скачиваем конфигурационный файл .openvpn

Открываем в браузере ссылку: [https://<адрес bastionVM>/setup](https://cloud.google.com)
[Создаем организацию и пользователя](https://docs.pritunl.com/v1/docs/connecting)
На вкладке *Users*  справа от имени пользователя скачиваем конфигурационный файл *.openvpn*
</details>

#
# Homework 6. Deploy test application

### В процессе сделано:
- Установлен и настроен **gcloud** для работы с нашим аккаунтом
- Создали хост с помощью **gcloud**
- Установили на нем ruby для работы приложения
- Установили и запустили MongoDB
- Развернули тестовое приложение, запустили и проверили его работу

### Как запустить проект:
<details><p>
  
- [Установите Google Cloud SDK](https://cloud.google.com/sdk/docs/)

- Подклучение к аккуанту
```bash
$ gcloud init
Welcome! This command will take you through the configuration of gcloud.
```
Проверить установку и настройку gcloud можно, используя команду **gcloud info** или **gcloud auth list**

- [Создадим instance](https://gist.githubusercontent.com/stv2509/a091d96977ceb7afb221f91277e69fad/raw/52d896086eccafa4e509bd8d72b44831c2c5c1a8/gcloud_test)
```bash
Created [https://www.googleapis.com/compute/v1/projects/infra-232512/zones/europe-west1-b/instances/reddit-app].
NAME        ZONE            MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP    EXTERNAL_IP    STATUS
reddit-app  europe-west1-b  g1-small                   10.132.15.192  35.233.74.235  RUNNING
```

- Подключемся к instance **35.233.74.235** по SSH и запустим подготовленные scripts:
  - скрипт install_ruby.sh - содержит команды по установке руби.
  - скрипт install_mongodb.sh - содержить команды по установке MongoDB
  - скрипт deploy.sh - содержит команды скачивания кода, установки зависимостей через bundler и запуск приложения.
  - создать правило файервола в GCP и открыть порт tcp:9292
  
- Проверим работоспособность приложения прейдя по ссылке *http://35.233.74.235:9292/*


testapp_IP = 35.233.74.235

testapp_port = 9292
</p></details>

#
# Homework 7. Building VM Images with HashiCorp Packer

### В процессе сделано:

- Для тестового приложения собран образ VM с предустановленными Ruby и MongoDB, при помощи Packer

### Описание работы:
<details><p>
  
  - **packer/ubuntu16.json** - Packer шаблон, содержащий описание образа VM, который мы хотим создать:
    <details><p>
	
    - ***type: "googlecompute"*** - что будет создавать виртуальную машину для билда образа (в нашем случае Google Compute Engine)
    - ***project_id: "infra-189607"*** - id вашего проекта
    - ***image_family: "reddit-base"*** - семейство образов к которому будет принадлежать новый образ
    - ***image_name: "reddit-base-{{timestamp}}"*** - имя создаваемого образа
	- ***source_image_family: "ubuntu-1604-lts"*** - что взять за базовый образ для нашего билда
	- ***zone: "europe-west1-b"*** - зона, в которой запускать VM для билда образа
    - ***ssh_username: "appuser"*** - временный пользователь, который будет создан для подключения к VM во время билда и выполнения команд провижинера
    - ***machine_type: "f1-micro"*** - тип инстанса, который запускается для билда
	- ***provisioners*** секция позволяет устанавливать нужное ПО, производить настройки системы и конфигурацию приложений на созданной VM.
    </p></details>
  - **packer/variables.json** - Пользовательские переменные определяются в самом шаблоне, в файле **variables.json** задаются обязательные переменные, либо переопределяются
  
  - **Проверка шаблона на ошибки:**
  ```bash
  $ packer validate  -var-file=variables.json ubuntu16.json
  ```
  - **Запуск build образа:**
  ```bash
  $ packer build packer validate  -var-file=variables.json ubuntu16.json
  ```
  - **packer/files/startup_puma.sh** - содержить команды install_ruby.sh, install_mongodb.sh и deploy.sh
  
  - **packer/immutable.json** - Packer шаблон, содержащий образ VM все зависимости приложения и сам код приложения.
</p></details>

### Как проверить работоспособность:

- [Создадим instance на базе image_family=reddit-full, образ созданный на базе шаблона immutable.json](https://gist.githubusercontent.com/stv2509/6294d8a61e990238b13319a7fea09af9/raw/77523925fa4ceba5edcb5613a66b89793d5af848/gcloud_test-packer)
- Зайти на созданный instance, выполнить *"puma -d"* в папке ~/reddit

#
# Homework 8. Practice Infrastructure as Code using Terraform-1

### В процессе сделано:

- Создан instance при помощи Terraform

### Описание работы:

<details><p>

- Описание конфигурационных файлов:
  <details><p>

  - **terraform/main.tf** - основной файл конфигурации
  - **terraform/outputs.tf** - аттрибут ресурсов (ресурс network)
  - **terraform/terraform.tfstate** - состояние системы
  - **terraform/variables.tf** - переменные и их описание (description)
  - **terraform/terraform.tfvars** - значение переменных, описанных в файле "variables.tf"
  
  Terraform автоматически будет использовать переменные, определенные в **terraform.tfvars**
  </p></details>

- Дальнейшие действия выполняются в дирректории **terraform/**
- Отформатируйте все конфигурационные файлы используя команду ***"terraform fmt"***
- Загрузим провайдер GCP и начнем его использовать ***"terraform init"***
- Удалим все созданные ресурсы ***"terraform destroy"***
- Выполните команду планирования изменений в директории "terraform/" ***"terraform plan"***
- Запуск и создание instances ***"terraform apply"***
- Удалим все созданные ресурсы ***"terraform destroy"***
</p></details>