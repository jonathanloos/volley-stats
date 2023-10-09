json.extract! user, :id, :first_name, :last_name, :jersey_number, :team_id, :role, :created_at, :updated_at
json.url user_url(user, format: :json)
