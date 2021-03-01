FROM threeal/threeal-bot:latest

# Install dependencies
RUN apt-get update && apt-get install -y supervisor git psmisc
RUN yarn global add server-redirect

# Setup Threeal bot modules
COPY . /app
RUN cd /app/bot && if [ -f 'package.json' ]; then yarn install; fi
RUN cd /app/nlu && if [ -f 'config.yml' ]; then rasa train; fi

# Copy Supervisor configuration
RUN cp /app/supervisor.conf /etc/supervisor/conf.d/threeal-bot.conf

CMD bash /app/start.bash
