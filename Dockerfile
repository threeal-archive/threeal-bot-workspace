FROM threeal/threeal-bot:latest

# Install Git and Supervisor
RUN apt-get update && apt-get install -y git supervisor

# Setup Threeal bot modules
COPY . /app
RUN cd /app/threeal-bot && [ -f 'package.json' ] && yarn install
RUN cd /app/threeal-bot-nlu && [ -f 'config.yml' ] && rasa train

# Copy Supervisor configuration
RUN cp /app/supervisor.conf /etc/supervisor/conf.d/threeal-bot.conf

CMD bash /app/start.bash
