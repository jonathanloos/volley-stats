function resetdb () {
  rails db:drop
  rails db:create
  rails db:migrate
  rails db:seed
}

function go () {
  rails s --binding 0.0.0.0 --port 3000
}