# Git Webhook Deploy And Notify Docker

Pull code is triggered via WebHook, then build the code. And send notifications.

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/git-webhook-deploy.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-deploy/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/git-webhook-deploy.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-deploy/)

This image is based on **[funnyzak/git-webhook](https://github.com/funnyzak/git-webhook-docker.git)** image, which is a 432 image.

Download size of this image is:

[![](https://images.microbadger.com/badges/image/funnyzak/git-webhook-deploy.svg)](http://microbadger.com/images/funnyzak/git-webhook-deploy)

[Docker hub image: funnyzak/git-webhook-deploy](https://hub.docker.com/r/funnyzak/git-webhook-deploy)

Docker Pull Command: `docker pull funnyzak/git-webhook-deploy`

Visit Url: [http://hostname:80/](#)

Webhook Url: [http://hostname:9000|80/hooks/git-webhook?token=HOOK_TOKEN](#)

---

## Available Configuration Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

### Base

* **USE_HOOK** : The web hook is enabled as long as this is present.
* **HOOK_TOKEN** : Custom hook security tokens, strings.
* **GIT_REPO** : If it is a private repository, and is ssh link, set the private key file with the file name ***id_rsa*** must be set. If you use https link, you can also set this format link type: ***https://GIT_TOKEN@GIT_REPO***.
* **GIT_BRANCH** : Select a branch for clone and auto hook match.
* **GIT_EMAIL** : Set your email for git (required for git to work).
* **GIT_NAME** : Set your name for git (required for git to work).
* **INSTALL_DEPS_COMMAND**: Optional. The command your framework provides for install your code depends.  eg: `npm ci`. left blank, will not execute.
* **BUILD_COMMAND**: Optional. The command your framework provides for compiling your code. eg: `npm run build`、`yarn build` . left blank, will not execute.
* **OUTPUT_DIRECTORY**: Optional. The directory in which your compiled will be located. left blank, will not execute.
* **STARTUP_COMMANDS** : Optional. Add any commands that will be run at the end of the start.sh script. left blank, will not execute.
* **AFTER_PULL_COMMANDS** : Optional. Add any commands that will be run after pull. left blank, will not execute.
* **BEFORE_PULL_COMMANDS** : Optional. Add any commands that will be run before pull. left blank, will not execute.
* **AFTER_PACKAGE_COMMANDS** : Optional. Add any commands that will be run after package. left blank, will not execute.

### Notify

* **NOTIFY_ACTION_LABEL**: Optional. notify action name define. default : `StartUp|BeforePull|AfterPull|AfterPackage`
* **NOTIFY_ACTION_LIST**: Optional. notify action list. included events will be notified. default : `BeforePull|AfterPackage`
* **NOTIFY_URL_LIST** : Optional. Notify link array , each separated by **|**
* **IFTTT_HOOK_URL_LIST** : Optional. ifttt webhook url array , each separated by **|** [Official Site](https://ifttt.com/maker_webhooks).
* **DINGTALK_TOKEN_LIST**: Optional. DingTalk Bot TokenList, each separated by **|** [Official Site](http://www.dingtalk.com).
* **JISHIDA_TOKEN_LIST**: Optional. JiShiDa TokenList, each separated by **|**. [Official Site](http://push.ijingniu.cn/admin/index/).
* **APP_NAME** : Optional. When setting notify, it is best to set.

---

## Volume Configuration

* **/root/.ssh** :  ssh key folder.
* **/app/target** :  builded code files will move to this folder.
* **/app/code** : git source code dir. docker work dir.
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

Base Demo Yaml.

 ```docker
version: '3'
services:
  webapp:
    image: funnyzak/git-webhook-deploy
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
      - HOOK_TOKEN=hello
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
      - JISHIDA_TOKEN_LIST=fklsjfklj23094lfjsd
    restart: on-failure
    ports:
      - 80:80
    volumes:
      - ./target:/app/target
      - ./code:/app/code
      - ./ssh:/root/.ssh
      - ./after_package:/custom_scripts/after_package

 ```

WebHook URL: [http://hostname/hooks/git-webhook?token=hello](#)

---

 VuePress YAML.

```Docker
  vuepressapp:
    image: funnyzak/git-webhook-deploy
    privileged: true
    container_name: vuepress
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
      - HOOK_TOKEN=6fcc11ace14c6
      - APP_NAME=VuePress Docs
      - GIT_REPO=git@github.com:youanme/reponame.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
      - INSTALL_DEPS_COMMAND=npm install
      - BUILD_COMMAND=npm run build
      - OUTPUT_DIRECTORY=.vuepress/dist/
      - NOTIFY_ACTION_LABEL=已启动|源码拉取中..|源码已拉取最新,开始打包..|部署已完成
      - NOTIFY_ACTION_LIST=StartUp|BeforePull|AfterPull|AfterPackage
      - DINGTALK_TOKEN_LIST=dingtoken_one|dingtoken_two
      - JISHIDA_TOKEN_LIST=jishida_token
    restart: on-failure
    ports:
      - 80:80
    volumes:
      - ./code:/app/code
      - ./target:/app/target
      - ./ssh:/root/.ssh
```

WebHook URL: [http://hostname/hooks/git-webhook?token=6fcc11ace14c6](#)

Web URL: [http://hostname](#)

---

 Hexo YAML.

```Docker
  hexoapp:
    image: funnyzak/git-webhook-deploy
    privileged: true
    container_name: hexo
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
      - HOOK_TOKEN=6fcc11ace14c6
      - APP_NAME=HexoBlog
      - GIT_REPO=git@github.com:youanme/reponame.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
      - INSTALL_DEPS_COMMAND=npm install
      - BUILD_COMMAND=npm run build
      - OUTPUT_DIRECTORY=public/
      - NOTIFY_ACTION_LABEL=已启动|源码拉取中..|源码已拉取最新,开始打包..|部署已完成
      - NOTIFY_ACTION_LIST=StartUp|BeforePull|AfterPull|AfterPackage
      - DINGTALK_TOKEN_LIST=dingtoken_one|dingtoken_two
      - JISHIDA_TOKEN_LIST=jishida_token
    restart: on-failure
    ports:
      - 80:80
    volumes:
      - ./code:/app/code
      - ./target:/app/target
      - ./ssh:/root/.ssh
```

Static Web YAML.

```Docker
  staticapp:
    image: funnyzak/git-webhook-deploy
    privileged: true
    container_name: static
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
      - HOOK_TOKEN=6fcc11ace14c6
      - APP_NAME=staticsite
      - GIT_REPO=git@github.com:youanme/reponame.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
      - OUTPUT_DIRECTORY=./
      - NOTIFY_ACTION_LABEL=已启动|更新拉取中..|部署已完成|部署已完成
      - NOTIFY_ACTION_LIST=StartUp|BeforePull|AfterPull
      - DINGTALK_TOKEN_LIST=dingtoken_one|dingtoken_two
      - JISHIDA_TOKEN_LIST=jishida_token
    restart: on-failure
    ports:
      - 80:80
    volumes:
      - ./code:/app/code
      - ./ssh:/root/.ssh
```

WebHook URL: [http://hostname/hooks/git-webhook?token=6fcc11ace14c6](#)

Web URL: [http://hostname](#)

---

Node App Deploy.

```Docker
  nodeapp:
    image: funnyzak/git-webhook-deploy
    privileged: true
    container_name: node
    working_dir: /app/code
    logging:
      driver: 'json-file'
      options:
        max-size: '1g'
    tty: true
    environment:
      - TZ=Asia/Shanghai
      - LANG=C.UTF-8
      - NODE_ENV=production
      - USE_HOOK=1
      - HOOK_TOKEN=6fcc11ace14c6
      - APP_NAME=nodeapp
      - GIT_REPO=git@github.com:youanme/reponame.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
      - INSTALL_DEPS_COMMAND=npm install --production # if after pull then  install deps
      - NOTIFY_ACTION_LABEL=已启动|更新拉取中..|最新更新已拉取|已完成启动
      - NOTIFY_ACTION_LIST=StartUp|BeforePull|AfterPull|AfterPackage
      - DINGTALK_TOKEN_LIST=dingtoken_one|dingtoken_two
      - JISHIDA_TOKEN_LIST=jishida_token
    restart: on-failure
    ports:
      - 9000:9000 # hook url
      - 168:168 # node app port, Configured according to the actual listening port of the node app
    volumes:
      - ./start_app.sh:/custom_scripts/after_package/run_app.sh
      - ./ssh:/root/.ssh
      - ./code:/app/code
```

start_app.sh

```bash
#!/bin/bash

cd /app/code

NODE_ENPOINT_SCRIPT="index.js"  # your node enterpont script

tpid=`ps -ef|grep $NODE_ENPOINT_SCRIPT|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Stop App Process...'
    kill -15 $tpid
fi

sleep 5

echo "kill app thread."
ps ax |grep $NODE_ENPOINT_SCRIPT | awk '{print $1}' |xargs kill -9 ;

echo "start app .."
node $NODE_ENPOINT_SCRIPT NODE_ENV=production &  # your node run command

```

WebHook URL: [http://hostname:9000/hooks/git-webhook?token=6fcc11ace14c6](#)

NODE App URL: [http://hostname:168](#)

---

Java SpringBoot App Deploy.

```Docker
  springboot:
    image: funnyzak/git-webhook-deploy
    privileged: true
    container_name: springbootapp
    working_dir: /app/code
    logging:
      driver: 'json-file'
      options:
        max-size: '1g'
    tty: true
    environment:
      - spring.config.location=/app/target/application.yaml # your application yaml
      - spring.profiles.active=prod
      - TZ=Asia/Shanghai
      - LANG=C.UTF-8
      - USE_HOOK=1
      - HOOK_TOKEN=1234567890
      - APP_NAME=MySpringBootApp
      - GIT_REPO=git@github.com:youanme/reponame.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
      - BUILD_COMMAND=mvn -B clean package -Dmaven.test.skip=true -Dautoconfig.skip  # jar package command.
      - OUTPUT_DIRECTORY=web_modules/target/execute_jar_name.jar # setting your package jar file path
      - NOTIFY_ACTION_LABEL=已启动|更新拉取中..|最新更新已拉取|已完成启动
      - NOTIFY_ACTION_LIST=StartUp|BeforePull|AfterPull|AfterPackage
      - DINGTALK_TOKEN_LIST=dingtoken_one|dingtoken_two
      - JISHIDA_TOKEN_LIST=jishida_token
    restart: on-failure
    ports:
      - 9000:9000 # hook url
      - 168:168 # app port, Configured according to the actual listening port of the app
    volumes:
      - ./ssh/root/.ssh
      - ./start_app.sh:/custom_scripts/after_package/start.sh
      - ./code:/app/code
      - ./target:/app/target
```

start_app.sh

```bash
#!/bin/bash

cd /app/target

JAR_PACKAGE_NAME = "execute_jar_name.jar"

tpid=`ps -ef|grep $JAR_PACKAGE_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Stop App Process...'
    kill -15 $tpid
fi

sleep 5

echo "kill app thread."
ps ax |grep $JAR_PACKAGE_NAME | awk '{print $1}' |xargs kill -9 ;

echo "run java -jar /app/target/$JAR_PACKAGE_NAME"
nohup java -jar /app/target/$JAR_PACKAGE_NAME &

```

WebHook URL: [http://hostname:9000/hooks/git-webhook?token=1234567890](#)

NODE App URL: [http://hostname:168](#)

---

Please configure according to the actual deployment path and port.
