class AuthenticateUser
  # Module that has hash errors and allows to execute class' new and call together in call
  prepend SimpleCommand
  attr_accessor :user

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    @user = User.find_by_email(@email)
    return JsonWebToken.encode(user_id: @user.id) if @user&.authenticate(@password)

    errors.add :user_authentication, ''
    false
  end
end
