class GroupsQueryForm < Form
  attribute :updated_after, Time

  class << self
    def from_params(params)
      new params.symbolize_keys.slice(:updated_after)
    end
  end
end
