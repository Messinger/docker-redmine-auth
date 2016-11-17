require 'utils/attributes_accessor'
require 'gitlab_http'
require 'http_exceptions'
require 'user_presentation_model'

module Gitlab
  class GitlabUser < UserPresentationModel
    @@class_attributes_elements = %w[ name username id state avatar_url web_url is_admin:bool extern:bool private_token ]
    include AttributesAccessor

    def self.login _username, _password

      begin
        _u = GitlabHttp.new('session').create({:login => _username, :password => _password})
        GitlabUser.new({:data => _u})
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

    def projects
      @projects ||= retrieve_projects
    end

    private

    def retrieve_projects

      projects = []
      begin
        _r = GitlabHttp.new('projects',authtoken).retrieve('visible')

        projects = _r.map do |rp|
          Gitlab::GitlabProject.new({:data => rp})
        end

      rescue HttpExceptions::RequestException => e
        []
      end

      projects

    end

  end
end
