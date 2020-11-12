class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    render json: { auth_token: command.result, user: command.user } if command.result
    raise ApplicationController::NotAuthorized
  end
end
