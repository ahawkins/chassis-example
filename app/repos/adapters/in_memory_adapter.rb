class InMemoryAdapter < Chassis::Repo::InMemoryAdapter
  def query_auth_token_with_code(klass, q)
    all(klass).find do |auth_token|
      auth_token.code == q.code
    end
  end
end
