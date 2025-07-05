#!/bin/bash

# credit: Yt coding with sphere: https://www.youtube.com/watch?v=jLA6-R8aN70
topic_constraint="none"

while [[ "$#" -gt 0 ]]; do
  case $1 in
  l | lang)
    topic_constraint="lang"
    shift
    ;;
  esac
done

topic=""
if [[ "$topic_constraint" == "lang" ]]; then
  topic=$(printf "go\nrust\nc" | fzf --preview='')
  stty sane
else
  topic=$(curl -s cht.sh/:list | fzf --preview='')
  stty sane
fi

if [[ -z "$topic" ]]; then
  exit 0
fi

sheet=$(curl -s cht.sh/$topic/:list | fzf)

if [[ -z "$sheet" ]]; then
  curl -s cht.sh/$topic?style=rrt
  exit 0
fi

curl -s cht.sh/$topic/$sheet?style=rrt
