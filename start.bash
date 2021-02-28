#!/bin/bash

check_repo () {
  REPO="$1"
  BRANCH="$2"
  LOCATION="$3"

  # Check if is the same repo
  if cd "$LOCATION" && [ -f '.git' ] \
    && [ "$REPO" = "$(&& git remote get-url origin)" ]; then
    git pull origin HEAD
  else
    cd / && rm -rf $LOCATION || return $?

    # Clone with or without specific branch
    if [ -z "$BRANCH" ]; then
      git clone "$REPO" "$LOCATION" || return $?
    else
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

supervisord
