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
    if user = authenticate_with_http_basic { |u, p| RedmineUser.login(u, p) }
      raise NotAuthenticated.new if user.nil?
      debug user.to_hash
      @current_user = user
    else
      request_http_basic_authentication
    end
  end

  def generate_auth_token
    aud = Setting.service_name
    jti_raw = [@current_user.api_key, Time.now.to_i].join(':').to_s
    payload = {:iss => Setting.docker_issuer, :aud => aud}.merge generate_access
    debug payload
    AuthToken.encode(payload,$ssl_key,jti_raw,Setting.token_timeout.to_i.seconds.from_now)
  end

  # this moment without further checks!
  def generate_access
    _scope = params[:scope].split(':') unless params[:scope].blank?
    if _scope.blank? || _scope.length != 3
      {}
    else
      {:access => [{:type => _scope[0], :name => _scope[1], :actions => _scope[2].split(',')}]}
    end
  end

end
