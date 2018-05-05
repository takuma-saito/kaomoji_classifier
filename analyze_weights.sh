#!/bin/zsh -e
INDEX=${1:-0}
NUM=${2:-5}
DIR=${3:-training_data/data_set_0}
NAME=$(cat $DIR/training_data.json | jq -r '.answers["'$INDEX'"] | .name')
cat $DIR/weights.json |
    jq -r ".[$INDEX] | to_entries | sort_by(.value) | (.[-$[$NUM + 1]:-1] | reverse) | [.[] | [.key, .value]] | .[] | @csv" |
    while read line
    do
        printf $line, ","; {
        echo $line | awk -F',' '{print $1}' | xargs -I{} zsh -lc 'num=$[[##16] {}]; printf "$num,\u$num",'
    };
        echo $NAME
    done
