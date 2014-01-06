module Validation
  class ValidationFailedError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def to_s
      errors.messages
    end

    def as_json
      errors.as_json
    end
  end

  class ErrorCollection
    def initialize
      @store = { }
    end

    def messages
      store.inspect
    end

    def empty?
      store.empty?
    end

    def add(field, message)
      store[field.to_sym] ||= []
      store[field.to_sym] << message
    end

    def to_h
      store
    end

    def as_json
      to_h
    end

    def clear
      store.clear
    end

    private
    def store
      @store
    end
  end

  attr_reader :errors

  def initialize(*args)
    super
    @errors = ErrorCollection.new
  end

  def valid?
    errors.clear
    validate
    errors.empty?
  end

  def validate!
    raise ValidationFailedError, errors unless valid?
    true
  end
end
