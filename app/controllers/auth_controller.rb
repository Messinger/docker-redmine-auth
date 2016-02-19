require 'auth_token'

class AuthController < ApplicationController

  before_action :authenticate

  def index

    service=params[:service]
    scope=params[:scope]

    render :json => {:token => generate_auth_token, :expires_in => 3600, :issued_at => DateTime.now.iso8601}

  end

  private

  def authenticate

    case request.format
      when Mime::XML,Mime::JSON
        if user = authenticate_with_http_basic { |u, p| redmine_authenticate(u, p) }
          @current_user = user
        else
          request_http_basic_authentication
        end
      else
        raise BadRequest
    end
  end

  def redmine_authenticate u, p
    auth = {:username => u, :password => p}
    blah = HTTParty.get("#{Setting.redmine_url}/users/current.json",:basic_auth => auth)

    if blah.code == 200
      blah.body
    else
      raise NotAuthenticated.new
    end
  end

  def generate_auth_token
    payload = { issuer: Setting.docker_issuer }
    AuthToken.encode(payload,$ssl_key)
  end

end
