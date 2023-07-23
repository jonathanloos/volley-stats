function help () {
  echo "commands:"
  echo
  echo "  go - start the rails server and bind host & ports"
  echo "  db - reset the database with seed data"
}

function go () {
  bundle exec rails s --binding 0.0.0.0 --port 3000
}

function db () {
  bundle exec rails db:drop
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
}

help