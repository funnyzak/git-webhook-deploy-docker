# Git Webhook Node Build And Notify Docker

Pull code is triggered via WebHook, then build the code. And send notifications.

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/git-webhook-node-build.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-node-build/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/git-webhook-node-build.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-node-build/)

This image is based on Alpine Linux image, which is a 169 image.

Download size of this image is:

[![](https://images.microbadger.com/badges/image/funnyzak/git-webhook-node-build.svg)](http://microbadger.com/images/funnyzak/git-webhook-node-build)

[Docker hub image: funnyzak/git-webhook-node-build](https://hub.docker.com/r/funnyzak/git-webhook-node-build)

Docker Pull Command: `docker pull funnyzak/git-webhook-node-build`

Visit Url: [http://hostname:80/](#)

Webhook Url: [http://hostname:80/hooks/git-webhook](#)

---

## Available Configuration Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

### Base

* **USE_HOOK** : The web hook is enabled as long as this is present.
* **GIT_REPO** : URL to the repository containing your source code.
* **GIT_BRANCH** : Select a branch for clone and auto hook.
* **GIT_EMAIL** : Set your email for code pushing (required for git to work)
* **GIT_NAME** : Set your name for code pushing (required for git to work)
* **INSTALL_DEPS_COMMAND**: The command your frontend framework provides for install your code depends.  default is: `npm install`
* **BUILD_COMMAND**: The command your frontend framework provides for compiling your code. eg: `npm run build`、`yarn build`
* **OUTPUT_DIRECTORY**: The directory in which your compiled frontend will be located. default is "."
* **STARTUP_COMMANDS** : Add any commands that will be run at the end of the start.sh script
* **AFTER_PULL_COMMANDS** : Add any commands that will be run after pull
* **BEFORE_PULL_COMMANDS** : Add any commands that will be run before pull
* **AFTER_PACKAGE_COMMANDS** : Add any commands that will be run after package.

### Notify

* **NOTIFY_ACTION_LABEL**: Optional. notify action name define. default : `StartUp|BeforePull|AfterPull|AfterPackage`
* **NOTIFY_ACTION_LIST**: Optional. notify action list. included events will be notified. default : `BeforePull|AfterPackage`
* **NOTIFY_URL_LIST** : Optional. Notify link array , each separated by **|**
* **IFTTT_HOOK_URL_LIST** : Optional. ifttt webhook url array , each separated by **|**
* **DINGTALK_TOKEN_LIST**: Optional. DingTalk Bot TokenList, each separated by **|**
* **APP_NAME** : Optional. When setting notify, it is best to set.

---

## Volume Configuration

* **/app/target** :  builded code files will move to this folder.
* **/app/code** : git source code dir. docker work dir.
* **/root/.ssh** :  If it is a private repository, please set ssh key
* **/custom_scripts/on_startup** :  which the scripts are executed at startup, traversing all the scripts and executing them sequentially
* **/custom_scripts/before_pull** :  which the scripts are executed at before pull
* **/custom_scripts/after_pull** :  which the scripts are executed at after pull
* **/custom_scripts/after_package** :  which the scripts are executed at after package.

### ssh-keygen

`ssh-keygen -t rsa -b 4096 -C "youremail@gmail.com" -N "" -f ./id_rsa`

---

## Display Package Elapsed Time

show package elapsed second.

```sh
docker exec servername cat /tmp/ELAPSED_TIME
```

show package elapsed time label.

```sh
docker exec servername cat /tmp/ELAPSED_TIME_LABEL
```

show git commit hash that currently deployed successfully.
```sh
docker exec servername cat /tmp/CURRENT_GIT_COMMIT_ID
```

---

## Docker-Compose

 ```docker
version: '3'
services:
  webapp:
    image: funnyzak/git-webhook-node-build
    privileged: true
    container_name: webapp
    working_dir: /app/code
    logging:
      driver: 'json-file'
      options:
        max-size: '1g'
    tty: true
    environment:
      - TZ=Asia/Shanghai
      - LANG=C.UTF-8
      - USE_HOOK=1
      - GIT_REPO=https://github.com/vuejs/vuepress.git
      - GIT_BRANCH=master
      - GIT_EMAIL=abc@gmail.com
      - GIT_NAME=potato
      - INSTALL_DEPS_COMMAND=npm install
      - BUILD_COMMAND=npm run build
      - OUTPUT_DIRECTORY=.vuepress/dist/
      - AFTER_PACKAGE_COMMANDS=echo "elapsed time: $(cat /tmp/ELAPSED_TIME_LABEL)"
      - APP_NAME=vuepress_app
      - NOTIFY_ACTION_LABEL=已启动|准备拉取代码|代码已拉取|打包部署完成
      - NOTIFY_ACTION_LIST=StartUp|BeforePull|AfterPull|AfterPackage
      - NOTIFY_URL_LIST=https://request.worktile.com/asdfsfwe
      - IFTTT_HOOK_URL_LIST=https://maker.ifttt.com/trigger/event_name/with/keyhelloworld
      - DINGTALK_TOKEN_LIST=sldfj2hr923rsf2938u4sdfsf|lsdf203sjdf
    restart: on-failure
    ports:
      - 168:80
    volumes:
      - ./target:/app/target
      - ./code:/app/code
      - ./ssh:/root/.ssh
      - ./after_package:/custom_scripts/after_package

 ```

---

Please configure according to the actual deployment path and port.
