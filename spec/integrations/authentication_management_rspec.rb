require 'rails_helper'

RSpec.describe 'Authentication Management', type: :request do
  it 'should be able to update a user password' do
    user = create(:user)

    headers = { Authorization: JsonWebToken.encode(user_id: user.id) }
    new_password = 'newPassword'

    # Change user password
    put "/users/#{user.id}", params: { user: { password: new_password } }, headers: headers

    # Login user with new password
    post '/login', params: { email: user.email, password: new_password }
    expect(response.code).to eql '200'
  end
end
