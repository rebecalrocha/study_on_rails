class JsonWebToken
  class << self
    def encode(payload, exp = 42.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secret_key_base)
    end

    def decode(token)
      return false unless token

      body = JWT.decode(token, Rails.application.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    end
  end
end
