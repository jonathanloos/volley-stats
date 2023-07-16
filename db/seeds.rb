# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Team.create(name: "Apex")
User.create(first_name: "Jonathan", last_name: "Loos", team: Team.all.first, jersey_number: 14, position: :head_coach)