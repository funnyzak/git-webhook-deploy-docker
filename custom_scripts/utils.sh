#!/bin/sh

notify_url(){
    # get current timestamp
    ts=$(date +%s)
    
    curl "$1" \
        -H "Content-Type: application/json" \
        -d "{
                \"_time\": \"$ts\",
                \"_name\": \"$HOOK_NAME\",
                \"_action\": \"$2\"
        }"
    curl -G "$1" \
        -d "_time=$ts&_name=$HOOK_NAME&_action=$2"
}

# $1 = action
do_notify(){
    if [ -n "$WEBHOOK_LIST" ]; then
        echo "$1 will notify url list >>> $WEBHOOK_LIST"
        url_array=${WEBHOOK_LIST//|/}

        for url_item in $url_array
        do
            echo "Notify to > ${url_item}"
            notify_url ${url_item} "$1"
        done
    fi
}

# if $1 has value then cacle package time 
# start:elasped_package_time 
# end: elasped_package_time "end"
elasped_package_time(){
    if [ -n "$1" ]; then
        # 计算部署耗时
        PULL_START_TS=`cat /tmp/PULL_START_TS`
        ELAPSED_TIME=`expr $(date +%s) - $PULL_START_TS`
        ELAPSED_TIME_M=`expr $ELAPSED_TIME / 60`
        ELAPSED_TIME_S=`expr $ELAPSED_TIME % 60`
        ELAPSED_TIME_LABEL="${ELAPSED_TIME_M}分${ELAPSED_TIME_S}秒"
        if [ $ELAPSED_TIME -ge 60 ]
        then
            ELAPSED_TIME_LABEL="${ELAPSED_TIME_M}分${ELAPSED_TIME_S}秒"
        else
            ELAPSED_TIME_LABEL="${ELAPSED_TIME_S}秒"
        fi
        # 耗时临时缓存
        echo $ELAPSED_TIME > /tmp/ELAPSED_TIME
        echo $ELAPSED_TIME_LABEL > /tmp/ELAPSED_TIME_LABEL
    else
        echo $(date +%s) > /tmp/PULL_START_TS
    fi
}





# checks if branch has something pending
parse_git_dirty() {
    git diff --quiet --ignore-submodules HEAD 2>/dev/null
    [ $? -eq 1 ] && echo "*"
}

# gets the current git branch
parse_git_branch() {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# get last commit hash prepended with @ (i.e. @8a323d0)
parse_git_hash() {
    git rev-parse --short HEAD 2>/dev/null | sed "s/\(.*\)/@\1/"
}

# get last commit message
parse_git_message() {
    git show --pretty=format:%s -s HEAD 2>/dev/null
}
