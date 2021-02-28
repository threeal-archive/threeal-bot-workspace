#!/bin/bash

redirector -u https://discord.com/app -p $PORT &

check_repo () {
  REPO="$1"
  BRANCH="$2"
  LOCATION="$3"

  echo "checking $REPO on branch $BRANCH of $LOCATION"

  # Check if is the same repo
  if cd "$LOCATION" && [ -f '.git' ] \
    && [ "$REPO" = "$(&& git remote get-url origin)" ]; then
    echo "pulling repo"
    git pull origin HEAD || return $?
  else
    echo "removing repo"
    cd / && rm -rf $LOCATION || return $?

    # Clone with or without specific branch
    if [ -z "$BRANCH" ]; then
      echo "cloning on master"
      git clone "$REPO" "$LOCATION" || return $?
    else
      echo "cloning on $branch"
      git clone -b "$BRANCH" "$REPO" "$LOCATION" || return $?
    fi
  fi
}

# Prepare Threeal bot from specific repo and branch
if [ ! -z "$BOT_REPO" ]; then
  if check_repo "$BOT_REPO" "$BOT_REPO_BRANCH" /app/threeal-bot || exit $?; then
    cd /app/threeal-bot && yarn install || exit $?
  fi
fi

# Prepare Threeal bot NLU from specific repo and branch
if [ ! -z "$NLU_REPO" ]; then
  if check_repo "$NLU_REPO" "$NLU_REPO_BRANCH" /app/threeal-bot-nlu || exit $?; then
    cd /app/threeal-bot-nlu && rasa train || exit $?
  fi
fi

killall node

supervisord
