Fabricator :user do
  name { sequence(:name) { |i| "User #{i}" } }
  phone_number { "+#{(rand * 10**9).to_i}" }

  token { SecureRandom.hex 32 }

  device do
    Device.new uuid: SecureRandom.hex(16), push_token: SecureRandom.hex(8)
  end
end
