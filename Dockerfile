FROM threeal/threeal-bot:latest

COPY . /app/

# Setup Threeal Bot
RUN cd /app/threeal-bot && yarn install

# Setup Threeal Bot NLU
RUN cd /app/threeal-bot-nlu && rasa train

# Install Supervisor
RUN apt-get update && apt-get install -y supervisor

# Copy Supervisord configuration
COPY supervisor.conf /etc/supervisor/conf.d/threeal-bot.conf

CMD /usr/bin/supervisord
