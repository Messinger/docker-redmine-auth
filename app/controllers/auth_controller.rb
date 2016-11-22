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

    if user = authenticate_with_http_basic { |u, p| check_authentications(u, p) }
      @current_user = user
      debug @current_user.as_json(:except => ['auth'])
    else
      if request.headers['X-Requested-With'] == 'XMLHttpRequest'
        self.headers["WWW-Authenticate"] = %(xBasic realm="Application")
        self.response_body = "HTTP Basic: Access denied.\n"
        self.status = 401
      else
        request_http_basic_authentication
      end
    end

  end

  def check_authentications _user,_password
    logins = []

    Setting.auth_modules.each do |authmodule|
      begin
        a = Object.const_get(authmodule.camelcase).const_get("#{authmodule.camelcase}User").login(_user,_password)
        unless a.nil?
          logins << a
        end
      rescue => _

      end
    end

    if logins.count > 0
      DockerUser.new _user,logins
    else
      nil
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
    return {} unless params.key? :scope
    _scope = params[:scope].split(':')
    if _scope.blank? || _scope.length != 3
      # login type / ping - no access check needed
      {}
    else
      _actions = _scope[2].split(',')

      if Setting.full_access_check && !Setting.admin_users.include?(@current_user.login)
        _temp_actions = []
        @redmine_project_id =  gen_context_name(_scope[1]) unless _scope[1].blank?
        if @redmine_project_id == 'catalog' && _scope[0]=='registry'
          _temp_actions << '*'
        else
          unless @redmine_project_id.blank?
            if _actions.include? '*'
              _temp_actions << '*' if @current_user.can_read?(@redmine_project_id) && @current_user.can_write?(@redmine_project_id)
            else
              _temp_actions << 'pull' if @current_user.can_read? @redmine_project_id
              _temp_actions << 'push' if @current_user.can_write? @redmine_project_id
            end
          end
        end
        _actions = _temp_actions
      else
        # ensure r/w rights, sometimes registry is confused when giving just 'pull'
        _actions = ['pull','push'] if _actions.include? 'pull'
      end
      {:access => [{:type => _scope[0], :name => _scope[1], :actions => _actions }]}
    end
  end

  private

  def gen_context_name _scope
    '' if _scope.blank?
    _r = _scope.split('/')[0..-2].join('/')
    if _r.blank?
      _r = _scope.split('/')[0]
    end
    _r
  end
end
