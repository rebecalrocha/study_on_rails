# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, :email, presence: true
  validates :password, length: { minimum: 4 }
  validates :age, numericality: { only_integer: true }

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
end
