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