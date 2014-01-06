module Serialization
  def read_attribute_for_serialization(name)
    value = send name

    case value
    when Time then value.utc.iso8601
    else value
    end
  end

  def active_model_serializer
    @serializer ||= "#{self.class}Serializer".constantize
  end
end
