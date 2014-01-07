class InMemoryAdapter < Chassis::Repo::InMemoryAdapter
  def create(record)
    create_method = "create_#{record.class.name.underscore}"
    send create_method, record if respond_to? create_method
    super
  end

  def create_group(group)
    group.created_at = Time.now.utc
    group.updated_at = Time.now.utc
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
end
