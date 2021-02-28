#!/bin/bash

# Prepare Threeal bot from specific repo and branch
if [ ! -z $BOT_REPO ] && [ ! -z $BOT_REPO_BRANCH ]; then
  rm -rf /app/threeal-bot || exit $?
  git clone -b $BOT_REPO_BRANCH $BOT_REPO /app/threeal-bot || exit $?
  cd /app/threeal-bot && yarn install || exit $?
fi

# Prepare Threeal bot NLU from specific repo and branch
if [ ! -z $NLU_REPO ] && [ ! -z $NLU_REPO_BRANCH ]; then
  rm -rf /app/threeal-bot-nlu || exit $?
  git clone -b $NLU_REPO_BRANCH $NLU_REPO /app/threeal-bot || exit $?
  cd /app/threeal-bot-nlu && rasa train || exit $?
fi

supervisord
