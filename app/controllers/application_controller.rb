class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :user

  NotAuthorized = Class.new(StandardError) # ???

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render json: { errors: 'Not found' }, status: 404
  end

  rescue_from ApplicationController::NotAuthorized do |_exception|
    render json: { errors: 'Not authorized' }, status: 401
  end

  private

  def authenticate_request
    @user = AuthorizeApiRequest.call(request.headers).result
    raise ApplicationController::NotAuthorized unless @user
  end
end
