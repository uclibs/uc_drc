#!/bin/bash
set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

max_try=${WAIT_MAX_TRY:-20}
wait_seconds=${WAIT_SECONDS:-5}

if [ "$1" = 'server' ]; then
    # Wait for the Database
    echo "Checking Database Connectivity"
      if ! /scripts/wait-for.sh "db" "$max_try" "$wait_seconds"; then
        echo "Unable to connect to the database."
        exit 1
    fi

    if [ -f /opt/hyrax/tmp/pids/server.pid ]; then
        echo "Stopping Rails Server and Removing PID File"
        #ps aux |grep -i [r]ails | awk '{print $2}' | xargs kill -9
        rm -rf /opt/hyrax/tmp/pids/server.pid
    fi

    echo "Copy over Docker env variables"
    if [[ $(echo $DOCKER_HOST_HOSTNAME) = 'curly' ]]; then
      /bin/cp -f .env.development.docker.curly .env.development.local
    else 
      /bin/cp -f .env.development.docker .env.development
    fi

    echo "Install bundler"
    gem install bundler:2.0.2

    echo "Checking and Installing Ruby Gems"
    bundle check || bundle install

    echo "Running Database Migration"
    bundle exec rake db:migrate db:seed

    echo "Load Workflows"
    bundle exec rake hyrax:workflow:load

    echo "Initialize Default Admin Set"
    bundle exec rake hyrax:default_admin_set:create

    echo "create default collection types"
    bundle exec rake hyrax:default_collection_types:create

    echo "Load default metadata profile"
    bundle exec rake metadata_profile:load_default

    echo "Starting the Rails Server"
    bundle exec rails s -b 0.0.0.0
   # RAILS_ENV=production bundle exec puma -C config/puma.rb

elif [[ $1 = sidekiq* ]]; then
    # Wait for Redis
    echo "Checking Redis Connectivity"
    if ! /scripts/wait-for.sh "redis" "$max_try" "$wait_seconds"; then
        echo "Unable to connect to the redis database."
        exit 1
    fi

    # Wait for the rails server to start.
    # The reason for this is to prevent both the worker and web container
    # from trying to download the ruby gem dependencies at the same time.
    rails_max_try=${RAILS_MAX_TRY:-40}
    rails_wait_seconds=${RAILS_WAIT_SECONDS:-15}
    if ! /scripts/wait-for.sh "rails" "$rails_max_try" "$rails_wait_seconds"; then
        echo "Unable to connect to the rails server."
        exit 1
    fi

    echo "Copy over Docker env variables"
    /bin/cp -f .env.development.docker .env.development.local

    echo "Install bundler"
    gem install bundler:2.0.2

    echo "Checking and Installing Ruby Gems"
    bundle check || bundle install

    echo "Stopping Existing sidekiq Tasks"
    ps aux |grep -i [s]idekiq | awk '{print $2}' | xargs kill -9 || true

    echo "Starting Sidekiq"
    exec bundle exec sidekiq -c 1

elif [[ "$1" = 'test' ]]; then

    echo "Copy over Docker env variables"
    /bin/cp -f .env.test.docker .env.test.local

    echo "Checking and Installing Ruby Gems"
    bundle check || bundle install
    bundle exec rails db:migrate RAILS_ENV=test

    echo "Running Tests"
    if [[ $# -eq 2 ]] ; then
        exec bundle exec rake spec RAILS_ENV=test SPEC=$2
    else
        exec bundle exec rake spec RAILS_ENV=test CI=true
    fi
fi

exec "$@"
