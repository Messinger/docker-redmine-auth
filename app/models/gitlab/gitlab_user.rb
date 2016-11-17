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

    # ensure that project is kind of GitlabProject or identifier
    def can_write? _project
      return true if Setting.admin_users.include? self.username
    end

    # ensure that project is kind of GitlabProject or identifier
    def can_read? _project
      return true if Setting.admin_users.include? self.username
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
