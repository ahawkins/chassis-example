class CreateGroup
  attr_reader :form, :current_user

  def initialize(form, current_user)
    @form, @current_user = form, current_user
  end

  def run!
    form.validate!

    group = Group.new do |group|
      group.name = form.name
      group.admin = current_user
    end

    group.save

    group
  end
end
