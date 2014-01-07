Fabricator :group do
  name { sequence(:name) { |i| "Group #{i}" } }
  admin { Fabricate(:user) }

  users { |g| [g.fetch(:admin)] }
end
