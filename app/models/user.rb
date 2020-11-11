class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :password, length: { minimum: 4 }, on: :create
  validates :age, numericality: { only_integer: true }

  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
end
