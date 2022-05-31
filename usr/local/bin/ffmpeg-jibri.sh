#!/bin/bash

shopt -s huponexit
#set -o pipefail
#set -o errexit


_term() {
  local SIGNAL=$1
  if [ ! -z "${CHILD}" ]; then
   kill -${SIGNAL} "${CHILD}"
  fi
  exit 111
}

trap "_term SIGHUP" SIGHUP SIGINT SIGTRAP SIGBUS SIGFPE SIGUSR1 SIGUSR2 SIGSTKFLT SIGCHLD SIGCONT SIGTSTP SIGTTIN SIGTTOU SIGURG SIGPIPE SIGALRM
trap "_term SIGABRT" SIGABRT
trap "_term SIGTERM" SIGTERM
trap "_term SIGKILL" SIGKILL
trap "_term SIGQUIT" SIGQUIT
trap "_term SIGSTOP" SIGSTOP
trap "_term STOP" STOP


# start ffmpeg cross capturing X displays to video devices
/usr/bin/ffmpeg -re -f x11grab -r 60 -s 1280x720 -i :0 -f x11grab -r 60 -s 1280x720 -i :1 \
  -map 0 -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video1 \
  -map 1 -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0 > /tmp/ffmpeg-jibri.log &

CHILD=$!
wait ${CHILD} || exit 1

exit 0
