require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    user = create(:user)
    @token = JsonWebToken.encode(user_id: user.id)
  end

  it 'should be able to show all users' do
    create(:user)
    create(:user)

    request.headers['Authorization'] = @token
    get :index
    response_body = JSON.parse(response.body)

    # Expected to get 3 users:
    # the user who logged in and the other two who have just been created
    expect(response_body.size).to eql 3
    expect(response.code).to eql '200'
  end

  it 'should be able to show users by age' do
    create(:user, age: 11)
    create(:user, age: 99)

    request.headers['Authorization'] = @token
    get :index, params: { idade: 11 }
    response_body = JSON.parse(response.body)

    expect(response_body.size).to eql 1
  end

  it 'should be able to show a user' do
    user_params = attributes_for(:user)
    post :create, params: { user: user_params }
    response_body = JSON.parse(response.body)

    user_id = response_body['id']

    request.headers['Authorization'] = @token
    get :show, params: { id: user_id }

    expect(response_body['name']).to eql user_params[:name]
    expect(response_body['email']).to eql user_params[:email]
    expect(response_body['age']).to eql user_params[:age]
    expect(response.code).to eql '200'
  end

  it 'should be able to create a user when name, email, age and password are specified' do
    user_params = attributes_for(:user)
    post :create, params: { user: user_params }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql user_params[:name]
    expect(response_body['email']).to eql user_params[:email]
    expect(response_body['age']).to eql user_params[:age]
    expect(response.code).to eql '201'
  end

  it 'should fail to create when name is not specified' do
    user_params = attributes_for(:user, name: nil)
    post :create, params: { user: user_params }

    expect(response.code).to eql '422'
  end

  it 'should fail to create when email is not specified' do
    user_params = attributes_for(:user, email: nil)
    post :create, params: { user: user_params }

    expect(response.code).to eql '422'
  end

  it 'should fail to create when age is not specified' do
    user_params = attributes_for(:user, age: nil)
    post :create, params: { user: user_params }

    expect(response.code).to eql '422'
  end

  it 'should fail to create when password are not specified' do
    user_params = attributes_for(:user, password: nil)
    post :create, params: { user: user_params }

    expect(response.code).to eql '422'
  end

  it 'should be able to update a user name' do
    user = create(:user)

    request.headers['Authorization'] = @token
    put :update, params: { id: user.id, user: { name: 'Test' } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql 'Test'
    expect(response_body['email']).to eql user.email
    expect(response_body['age']).to eql user.age
    expect(response.code).to eql '200'
  end

  it 'should be able to update a user email' do
    user = create(:user)

    request.headers['Authorization'] = @token
    put :update, params: { id: user.id, user: { email: 'test@email.com' } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql user.name
    expect(response_body['email']).to eql 'test@email.com'
    expect(response_body['age']).to eql user.age
    expect(response.code).to eql '200'
  end

  it 'should be able to update a user age' do
    user = create(:user)

    request.headers['Authorization'] = @token
    put :update, params: { id: user.id, user: { age: 23 } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql user.name
    expect(response_body['email']).to eql user.email
    expect(response_body['age']).to eql 23
    expect(response.code).to eql '200'
  end

  it 'should fail to update when email if is not in the correct format' do
    user = create(:user)

    request.headers['Authorization'] = @token
    put :update, params: { id: user.id, user: { email: 'test@email' } }

    response_body = JSON.parse(response.body)

    expect(response_body['email']).to eql ['is invalid']
    expect(response.code).to eql '422'
  end

  it 'should be able to delete a user' do
    user = create(:user)

    request.headers['Authorization'] = @token
    delete :destroy, params: { id: user.id }

    expect(response.code).to eql '204'
  end
end
