#!/bin/bash

# Enabling job control
set -m

echo "starting a Supervisor daemon"
supervisord &
sleep 5

restart_supervisor() {
  echo "restarting a Supervisor daemon"
  supervisorctl stop all || return $?
  killall supervisord || return $?
  supervisord &
  sleep 5
}

# To update the repo contents
check_repo () {
  REPO="$1"
  BRANCH="$2"
  LOCATION="$3"

  echo "checking $REPO on branch $BRANCH of $LOCATION"

  # Check if is the same repo
  if cd "$LOCATION" && [ -f '.git' ] \
    && [ "$REPO" = "$(git remote get-url origin)" ]; then
    echo "pulling repo"
    git pull origin HEAD || return $?
  else
    echo "removing repo"
    cd / && rm -rf $LOCATION || return $?

    # Clone with or without specific branch
    if [ -z "$BRANCH" ]; then
      echo "cloning"
      git clone "$REPO" "$LOCATION" || return $?
    else
      echo "cloning on $branch"
      git clone -b "$BRANCH" "$REPO" "$LOCATION" || return $?
    fi
  fi
}

# Prepare the bot module
if [ ! -z "$BOT_REPO" ]; then
  if check_repo "$BOT_REPO" "$BOT_REPO_BRANCH" /app/bot || exit $?; then
    cd /app/bot && yarn install || exit $?
  fi
fi

# Prepare the NLU module
if [ -z "$NLU_URL" ]; then
  export NLU_URL=http://localhost:6000
  restart_supervisor || exit $?

  if [ -z "$NLU_REPO" ]; then
    if [ ! -z "$NLU_REPO" ]; then
      if check_repo "$NLU_REPO" "$NLU_REPO_BRANCH" /app/nlu || exit $?; then
        cd /app/nlu && rasa train || exit $?
      fi
    fi
  fi

  echo "starting the nlu module"
  supervisorctl start nlu || exit $?
fi

echo "starting the bot module"
supervisorctl stop redirector || exit $?
supervisorctl start bot || exit $?

fg
