require 'auth_token'
require 'json'

class AuthController < ApplicationController

  before_action :authenticate

  def index

    debug params
    render :json => {:token => generate_auth_token, :expires_in => Setting.token_timeout.to_i, :issuer => Setting.docker_issuer}, :status => :ok, :content_type => 'application/json; charset=utf-8'
  end

  private

  def authenticate
    if user = authenticate_with_http_basic { |u, p| redmine_authenticate(u, p) }
      @current_user = user
    else
      request_http_basic_authentication
    end
  end

  def redmine_authenticate u, p
    auth = {:username => u, :password => p}
    blah = HTTParty.get("#{Setting.redmine_url}/users/current.json",:basic_auth => auth)

    if blah.code == 200
      JSON.parse(blah.body)['user']
    else
      raise NotAuthenticated.new
    end
  end

  def generate_auth_token
    aud = Setting.service_name
    jti_raw = [@current_user['api_key'], Time.now.to_i].join(':').to_s
    #access = [{:type => 'registry', :actions => ['*'], :name => 'catalog'}]
    access = generate_access
    payload = {:iss => Setting.docker_issuer, :aud => aud, :access => [access]}
    debug payload
    AuthToken.encode(payload,$ssl_key,jti_raw,Setting.token_timeout.to_i.seconds.from_now)
  end

  # this moment without further checks!
  def generate_access
    _scope = params[:scope].split(':') unless params[:scope].blank?
    if _scope.blank? || _scope.length != 3
      {}
    else
      _action = _scope[2].split(',')

      {:type => _scope[0], :name => _scope[1], :actions => _action}
    end
  end

end
