require 'jwt'

class AuthToken

  # key is the whole key including public and private
  def self.encode(payload, key, exp=3600.seconds.from_now)

    payload[:exp] = exp.to_i
    _token = JWT.encode(payload, key, 'RS256')
  end

  # key is the PUBLIC key only
  def self.decode(token,key)
    payload = JWT.decode(token,key,true,{ :algorithm => 'RS256' })[0]
    DecodedAuthToken.new(payload)
  rescue
    nil # It will raise an error if it is not a token that was generated with our secret key or if the user changes the contents of the payload
  end

end

class DecodedAuthToken < HashWithIndifferentAccess
  def expired?
    self[:exp] <= Time.now.to_i
  end
end
