class QueryGroups
  attr_reader :form, :current_user

  def initialize(form, current_user)
    @form, @current_user = form, current_user
  end

  def results
    GroupRepo.for_user current_user, form.attributes

  end
end
