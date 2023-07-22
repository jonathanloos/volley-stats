function help () {
  echo "commands:"
  echo
  echo "  go - start the rails server and bind host & ports"
}

function go () {
  bundle exec rails s --binding 0.0.0.0 --port 3000
}

help