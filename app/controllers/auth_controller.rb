require 'auth_token'
require 'json'

class AuthController < ApplicationController

  before_action :authenticate

  def index

    warn params
    service=params[:service]
    scope=params[:scope]
    _token = generate_auth_token
    warn _token
    res = {:token => _token, :expires_in => 60, :issuer => Setting.docker_issuer}
    debug JSON::generate res
    render :json => res, :status => :ok, :content_type => 'application/json; charset=utf-8'
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
    aud = 'Docker registry'
    jti_raw = [@current_user['api_key'], Time.now.to_i].join(':').to_s
    #access = [{:type => 'registry', :actions => ['*'], :name => 'catalog'}]
    payload = {:iss => Setting.docker_issuer, :exp =>  Time.now.to_i + 3600, :aud => aud}
    AuthToken.encode(payload,$ssl_key,jti_raw)
  end

end
