require 'gitlab_http'
require 'http_exceptions'
require 'user_presentation_model'

module Gitlab
  class GitlabUser < UserPresentationModel

    def self.login _username, _password

      begin
        _u = GitlabHttp.new('session').create({:login => _username, :password => _password})
        GitlabUser.new(_u)
      rescue HttpExceptions::RequestException => e
        raise HttpExceptions::Unauthorized.new
      end

    end

    def authtoken
      {:accesstoken => private_token}
    end

    def api_key
      privat_token
    end

    def extra_hash options = {}
      {:projects => projects.map {|item| item.to_hash(options) }}
    end

    # identifier is the path! even the last part or the full path
    # identifier may even secured (eg, string.parameterize) form or url form
    # first match wins
    def find_project_by_identifier identifier
      projects.find{|x|  [x.safe_path_with_namespace,x.path_with_namespace, x.safe_name_with_namespace].include? identifier}
    end

    def projects
      @projects ||= retrieve_projects
    end

    # ensure that project is kind of GitlabProject
    def can_write? _project
      return true if Setting.admin_users.include? self.username
      has_permission_value(_project,30)
    end

    # ensure that project is kind of GitlabProject
    def can_read? _project
      return true if Setting.admin_users.include? self.username
      has_permission_value(_project,20)
    end

    def has_permission_value _project,value
      projects_permissions(_project).group_access >= value || projects_permissions(_project).project_access >= value
    end

    def projects_permissions _project
      @projects_permissions = {} if @projects_permissions.nil?
      unless @projects_permissions.key?(_project.id)
        _ga = if _project.permissions.group_access.nil?
                0
              else
                _project.permissions.group_access.access_level
              end
        _pa = if _project.permissions.project_access.nil?
                0
              else
                _project.permissions.project_access.access_level
              end
        @projects_permissions[_project.id] = PresentationModel.new({:group_access => _ga,:project_access => _pa})
      end
      @projects_permissions[_project.id]
    end

    def retrieve_project_permissions project_id
      begin
        _r = GitlabHttp.new("projects/#{project_id}/members",authtoken).retrieve(self.id)
      rescue => ex
        _r = {:access_level => 0}
      end
      GitlabPermission.new _r
    end

    private

    def retrieve_projects

      projects = []
      begin
        _r = GitlabHttp.new('projects',authtoken).retrieve('visible')

        projects = _r.map do |rp|
          Gitlab::GitlabProject.new(rp)
        end

      rescue HttpExceptions::RequestException => e
        []
      end

      projects

    end

  end
end
