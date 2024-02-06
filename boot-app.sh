#! /bin/sh
echo "Starting app in $RAILS_ENV"

# check for environment variables
env | grep RAILS | sort| grep -v KEY
echo
env | sort | grep HANGAR | grep -v KEY | grep -v PASSWORD | grep -v TOKEN | grep -v SECRET
echo
echo

# exit in the event there is any error
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# If database exists, migrate. Otherwise, fail.
if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails db:migrate --trace

  # Sync geocoding library in the background
  # sh /app/maxmind.sh &

  # # Notify slack (do not fail if we have an issue sending it)
  # set +e
  # curl -X POST -H 'Content-type: application/json' \
  # --data '{"text":"'"[LIFT:$HANGAR_DEPLOYMENT]"' :rocket: Lift booting on '"$HOSTNAME"'"}'  \
  # $HANGAR_LIFT_SLACK_DEV_WEBHOOK
  # set -e

  # start puma
  bundle exec puma -C config/puma.rb
elif [ "$RAILS_ENV" = "test" ]; then
  # install gems
  echo "[DX] Installing ruby gems"
  bundle check || bundle install

  # install node packages
  echo "[DX] Installing node packages"
  yarn install --check-files

  # If database exists, migrate. Otherwise setup (restore from prod)
  echo "[DX] Migrating the database"
  bundle exec rails db:migrate

  # Always running in dev mode!
  echo "[DX] forcing mode to test"
  bundle exec rails db:environment:set RAILS_ENV=test

  # Let's get the party started
  echo "[DX] Booting the server"
  bundle exec rails s --binding 0.0.0.0 --port 3000
else
  # install gems
  # echo "[DX] Installing ruby gems"
  # bundle check || (bundle config set --local without 'test production' && bundle install)

  # install node packages
  # echo "[DX] Installing node packages"
  # yarn install --check-files

  # If database exists, migrate. Otherwise setup (restore from prod)
  # echo "[DX] Migrating the database"
  # bundle exec rails db:migrate

  # Always running in dev mode!
  echo "[DX] forcing mode to development"
  bundle exec rails db:environment:set RAILS_ENV=development

  # Let's get the party started
  echo "[DX] Booting the server"
  bundle exec rails s --binding 0.0.0.0 --port 3000
fi
