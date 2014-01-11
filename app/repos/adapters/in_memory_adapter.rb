class InMemoryAdapter < Chassis::Repo::InMemoryAdapter
  def find(klass, id)
    super klass, id.to_i
  end

  def query_auth_token_with_code(klass, q)
    all(klass).find do |auth_token|
      auth_token.code == q.code
    end
  end

  def query_user_with_token(klass, q)
    all(klass).find do |user|
      user.token == q.token
    end
  end

  def query_user_with_phone_number(klass, q)
    all(klass).find do |user|
      user.phone_number == q.phone_number
    end
  end

  def query_groups_for_user(klass, q)
    set = all(klass).select do |group|
      group.users.include? q.user
    end

    if q.updated_after
      set.select! do |group|
        group.updated_at.utc >= q.updated_after.utc
      end
    end

    set
  end
end
