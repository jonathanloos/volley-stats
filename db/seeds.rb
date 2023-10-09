# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Team.create(name: "Apex", year: 2023)
User.create(first_name: "Jonathan", last_name: "Loos", team: Team.all.first, jersey_number: 14)
User.create(first_name: "Joel", last_name: "Semplonius", team: Team.all.first, jersey_number: 14)

User.create(first_name: "Player", last_name: "1", team: Team.all.first, jersey_number: 1, role: :setter)
User.create(first_name: "Player", last_name: "2", team: Team.all.first, jersey_number: 2, role: :left_side)
User.create(first_name: "Player", last_name: "3", team: Team.all.first, jersey_number: 3, role: :left_side)
User.create(first_name: "Player", last_name: "4", team: Team.all.first, jersey_number: 4, role: :left_side)
User.create(first_name: "Player", last_name: "5", team: Team.all.first, jersey_number: 5, role: :left_side)
User.create(first_name: "Player", last_name: "6", team: Team.all.first, jersey_number: 6, role: :right_side)
User.create(first_name: "Player", last_name: "7", team: Team.all.first, jersey_number: 7, role: :right_side)
User.create(first_name: "Player", last_name: "8", team: Team.all.first, jersey_number: 8, role: :setter)
User.create(first_name: "Player", last_name: "9", team: Team.all.first, jersey_number: 9, role: :middle)
User.create(first_name: "Player", last_name: "10", team: Team.all.first, jersey_number: 10, role: :middle)
User.create(first_name: "Player", last_name: "11", team: Team.all.first, jersey_number: 11, role: :middle)
User.create(first_name: "Player", last_name: "13", team: Team.all.first, jersey_number: 12, role: :middle)
User.create(first_name: "Player", last_name: "13", team: Team.all.first, jersey_number: 13, role: :libero)
