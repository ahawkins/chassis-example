module Persistance
  extend ActiveSupport::Concern

  included do
    attr_accessor :id
  end

  module ClassMethods
    def create(*args, &block)
      record = new(*args, &block)
      record.save
      record
    end

    def repo
      @repo ||= "#{name}Repo".constantize
    end
  end

  def save
    repo.save self
  end

  def destroy
    repo.delete self
  end

  def save!
    save
  end

  def new_record?
    id.nil?
  end

  def ==(o)
    if o.instance_of? self.class
      o && o.id == id
    else
      false
    end
  end

  def eql?(o)
    self == o
  end

  def hash
    id
  end

  def repo
    self.class.repo
  end

  def inspect
    "<#{self.class.name}:#{id}>"
  end
end
