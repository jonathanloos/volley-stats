# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

apex = Team.create(name: "Apex", year: 2023, club: "Scorpions Volleyball Club")
hc_apex = User.create(first_name: "Jonathan", last_name: "L", team: apex, jersey_number: 14)
ac_apex = User.create(first_name: "Joel", last_name: "S", team: apex, jersey_number: 17)
apex.update(head_coach: hc_apex, assistant_coach: ac_apex)

exo = Team.create(name: "EXO", year: 2023)
hc_exo = User.create(first_name: "Bryson", last_name: "M", team: exo, jersey_number: 5)
hc_exo = User.create(first_name: "Rob", last_name: "W", team: exo, jersey_number: 99)
exo.update(head_coach: hc_exo, assistant_coach: hc_exo)

middle_1 = User.create(first_name: "Liam", last_name: "R", team: apex, jersey_number: 3, role: :middle)
left_side_1 = User.create(first_name: "Rylan", last_name: "C", team: apex, jersey_number: 4, role: :left_side)
right_side = User.create(first_name: "Nathan", last_name: "G", team: apex, jersey_number: 6, role: :right_side)
User.create(first_name: "Gabriel", last_name: "M", team: apex, jersey_number: 7, role: :setter)
setter = User.create(first_name: "Christian", last_name: "S", team: apex, jersey_number: 8, role: :setter)
left_side_2 = User.create(first_name: "Jacob", last_name: "H", team: apex, jersey_number: 9, role: :left_side)
User.create(first_name: "Neelan", last_name: "B", team: apex, jersey_number: 11, role: :middle)
User.create(first_name: "Jensen", last_name: "S", team: apex, jersey_number: 12, role: :left_side)
User.create(first_name: "Pablo", last_name: "G", team: apex, jersey_number: 13, role: :left_side)
middle_2 = User.create(first_name: "Joe", last_name: "K", team: apex, jersey_number: 16, role: :middle)
User.create(first_name: "Nathan", last_name: "D", team: apex, jersey_number: 19, role: :middle)

game = Game.create(title: "APEX Finals", home_team: apex, away_team: exo, date: DateTime.now)
volleyball_set = VolleyballSet.new(game: game, starting_setter_rotation: 1, setter_rotation: 1, serving_team: game.home_team, receiving_team: game.away_team)
VolleyballSets::CreateService.call(volleyball_set: volleyball_set, game: game)
VolleyballSets::LineupService.call(
  volleyball_set: volleyball_set,
  rotation_one_id: volleyball_set.players.find_by(user_id: setter.id).id,
  rotation_two_id: volleyball_set.players.find_by(user_id: left_side_1.id).id,
  rotation_three_id: volleyball_set.players.find_by(user_id: middle_1.id).id,
  rotation_four_id: volleyball_set.players.find_by(user_id: right_side.id).id,
  rotation_five_id: volleyball_set.players.find_by(user_id: left_side_2.id).id,
  rotation_six_id: volleyball_set.players.find_by(user_id: middle_2.id)
)

right_side = User.create(first_name: "Nick", last_name: "S", team: exo, jersey_number: 1, role: :setter)
middle_1 = User.create(first_name: "Cyrus", last_name: "K", team: exo, jersey_number: 2, role: :left_side)
libero = User.create(first_name: "Nathan", last_name: "SB", team: exo, jersey_number: 4, role: :libero)
User.create(first_name: "Elliott", last_name: "W", team: exo, jersey_number: 5, role: :left_side)
User.create(first_name: "Grayson", last_name: "C", team: exo, jersey_number: 8, role: :setter)
middle_2 = User.create(first_name: "Lucas", last_name: "A", team: exo, jersey_number: 11, role: :right_side)
left_side_1 = User.create(first_name: "Reese", last_name: "RC", team: exo, jersey_number: 13, role: :right_side)
User.create(first_name: "Danny", last_name: "S", team: exo, jersey_number: 14, role: :setter)
User.create(first_name: "Mason", last_name: "K", team: exo, jersey_number: 15, role: :right_side)
setter = User.create(first_name: "Aleksi", last_name: "E", team: exo, jersey_number: 17, role: :middle)
left_side_2 = User.create(first_name: "Elliot", last_name: "W", team: exo, jersey_number: 25, role: :middle)

game = Game.create(title: "EXO Finals", home_team: exo, away_team: apex, date: DateTime.now)
volleyball_set = VolleyballSet.new(game: game, starting_setter_rotation: 1, setter_rotation: 1, serving_team: game.home_team, receiving_team: game.away_team)
VolleyballSets::CreateService.call(volleyball_set: volleyball_set, game: game)
VolleyballSets::LineupService.call(
  volleyball_set: volleyball_set,
  rotation_one_id: volleyball_set.players.find_by(user_id: setter.id).id,
  rotation_two_id: volleyball_set.players.find_by(user_id: left_side_1.id).id,
  rotation_three_id: volleyball_set.players.find_by(user_id: middle_1.id).id,
  rotation_four_id: volleyball_set.players.find_by(user_id: right_side.id).id,
  rotation_five_id: volleyball_set.players.find_by(user_id: left_side_2.id).id,
  rotation_six_id: volleyball_set.players.find_by(user_id: middle_2.id).id,
  libero_id: volleyball_set.players.find_by(user_id: libero.id).id
)