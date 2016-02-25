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
      @current_user = user
      debug @current_user.as_json(:except => ['auth'])
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
    return {} unless params.key? :scope
    _scope = params[:scope].split(':')
    if _scope.blank? || _scope.length != 3
      # login type / ping - no access check needed
      {}
    else
      _actions = _scope[2].split(',')

      if Setting.full_access_check && !Setting.admin_users.include?(@current_user.login)
        _temp_actions = []
        names = _scope[1].split '/'
        @redmine_project_id = names[0] unless names.blank?
        # catalog is a special case for admins
        if @redmine_project_id == 'catalog'
          #_temp_actions << '*'
        else
          unless @redmine_project_id.blank?
            project = RedmineProject.find_by_identifier @redmine_project_id, @current_user
            if _actions.include? '*'
              _temp_actions << '*' if @current_user.can_read?(project) && @current_user.can_write?(project)
            else
              _temp_actions << 'pull' if @current_user.can_read? project
              _temp_actions << 'push' if @current_user.can_write? project
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

end
