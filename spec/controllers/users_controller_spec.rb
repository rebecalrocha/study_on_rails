require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it 'should be able to show all users' do
    post :create, params: { user: { name: 'UserOne', email: 'user_one@email.com', age: 11, password: 'password123' } }
    post :create, params: { user: { name: 'UserTwo', email: 'user_two@email.com', age: 22, password: 'password123' } }

    get :index
    response_body = JSON.parse(response.body)

    expect(response_body[0]['name']).to eql 'UserOne'
    expect(response_body[0]['email']).to eql 'user_one@email.com'
    expect(response_body[0]['age']).to eql 11
    expect(response_body[1]['name']).to eql 'UserTwo'
    expect(response_body[1]['email']).to eql 'user_two@email.com'
    expect(response_body[1]['age']).to eql 22

    expect(response.code).to eql '200'
  end

  it 'should be able to show users by age' do
    post :create, params: { user: { name: 'UserOne', email: 'user_one@email.com', age: 11, password: 'password123' } }
    post :create, params: { user: { name: 'UserTwo', email: 'user_two@email.com', age: 22, password: 'password123' } }

    get :index, params: { idade: 11 }
    response_body = JSON.parse(response.body)

    expect(response_body.size).to eql 1
  end

  it 'should be able to show a user' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }
    response_body = JSON.parse(response.body)
    user_id = response_body['id']

    get :show, params: { id: user_id }

    expect(response_body['name']).to eql 'Teste'
    expect(response_body['email']).to eql 'teste@email.com'
    expect(response_body['age']).to eql 45
    expect(response.code).to eql '200'
  end

  it 'should be able to create a user when name, email, age and password are specified' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql 'Teste'
    expect(response_body['email']).to eql 'teste@email.com'
    expect(response_body['age']).to eql 45
    expect(response.code).to eql '201'
  end

  it 'should fail to create when name is not specified' do
    post :create, params: { user: { email: 'teste@email.com', age: 45, password: 'password123' } }
    expect(response.code).to eql '422'
  end

  it 'should fail to create when email is not specified' do
    post :create, params: { user: { name: 'Teste', age: 45, password: 'password123' } }
    expect(response.code).to eql '422'
  end

  it 'should fail to create when age or password is not specified' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', password: 'password123' } }
    expect(response.code).to eql '422'
  end

  it 'should fail to create when password are not specified' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com' } }
    expect(response.code).to eql '422'
  end

  it 'should be able to update a user name' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }
    response_body = JSON.parse(response.body)
    user_id = response_body['id']

    put :update, params: { id: user_id, user: { name: 'User' } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql 'User'
    expect(response_body['email']).to eql 'teste@email.com'
    expect(response_body['age']).to eql 45
    expect(response.code).to eql '200'
  end

  it 'should be able to update a user email' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }
    response_body = JSON.parse(response.body)
    user_id = response_body['id']

    put :update, params: { id: user_id, user: { email: 'user@email.com' } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql 'Teste'
    expect(response_body['email']).to eql 'user@email.com'
    expect(response_body['age']).to eql 45
    expect(response.code).to eql '200'
  end

  it 'should be able to update a user age' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }
    response_body = JSON.parse(response.body)
    user_id = response_body['id']

    put :update, params: { id: user_id, user: { age: 23 } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql 'Teste'
    expect(response_body['email']).to eql 'teste@email.com'
    expect(response_body['age']).to eql 23
    expect(response.code).to eql '200'
  end

  it 'should be able to update a user password' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }
    response_body = JSON.parse(response.body)
    user_id = response_body['id']

    put :update, params: { id: user_id, user: { password: 'password123' } }

    response_body = JSON.parse(response.body)

    expect(response_body['name']).to eql 'Teste'
    expect(response_body['email']).to eql 'teste@email.com'
    expect(response_body['age']).to eql 45
    expect(response.code).to eql '200'
  end

  it 'should fail to update when email if is not in the correct format' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }
    response_body = JSON.parse(response.body)
    user_id = response_body['id']

    put :update, params: { id: user_id, user: { email: 'user@email' } }

    response_body = JSON.parse(response.body)

    expect(response_body['email']).to eql ['is invalid']
    expect(response.code).to eql '422'
  end

  it 'should be able to delete a user' do
    post :create, params: { user: { name: 'Teste', email: 'teste@email.com', age: 45, password: 'password123' } }
    response_body = JSON.parse(response.body)
    user_id = response_body['id']

    delete :destroy, params: { id: user_id }

    print(response)
    expect(response.code).to eql '204'
  end
end
