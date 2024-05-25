#!/usr/bin/bash
# if ssh-agent dies and keeps restarting, then:
# 1. kill all instances of ssh-agent
# 2. close all terminals except for one
# 3. unset SSH_AGENT_PID and SSH_AUTH_SOCK
# 4. source ~/.bashrc
if [ -z "$SSH_AGENT_PID" ]; then
  if [ -f ~/.ssh/ssh_agent_pid ]; then
    SSH_AGENT_PID=`cat ~/.ssh/ssh_agent_pid`
    SSH_AUTH_SOCK=`cat ~/.ssh/ssh_agent_sock`
  fi
fi

if ps -p $SSH_AGENT_PID &> /dev/null; then
  echo "ssh-agent is already running"
else
  eval `ssh-agent -s`
  echo "$SSH_AGENT_PID" > ~/.ssh/ssh_agent_pid
  echo "$SSH_AUTH_SOCK" > ~/.ssh/ssh_agent_sock
fi

export SSH_AGENT_PID
export SSH_AUTH_SOCK
