require 'gitlab_http'
require 'http_exceptions'
require 'user_presentation_model'

module Gitlab
  class GitlabUser < UserPresentationModel

    def self.login(_, apitoken)

      begin
        # raise error if token invalid
        GitlabHttp.new('user',{:accesstoken => apitoken}).retrieve
        GitlabUser.new({:accesstoken => apitoken})
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

    def extra_hash(options = {})
      {:projects => projects.map {|item| item.to_hash(options)}}
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
    def can_write?(project)
      return true if Setting.admin_users.include? self.username
      has_permission_value(project, 30)
    end

    # ensure that project is kind of GitlabProject
    def can_read?(project)
      return true if Setting.admin_users.include? self.username
      has_permission_value(project, 20)
    end

    def has_permission_value(project, value)
      projects_permissions(project).group_access >= value || projects_permissions(project).project_access >= value
    end

    def projects_permissions(project)
      if @projects_permissions.nil?
        @projects_permissions = {}
      end
      unless @projects_permissions.key?(project.id)
        group_a = if project.permissions.group_access.nil?
                    0
                  else
                    project.permissions.group_access.access_level
                  end
        project_a = if project.permissions.project_access.nil?
                      0
                    else
                      project.permissions.project_access.access_level
                    end
        @projects_permissions[project.id] = PresentationModel.new({:group_access => group_a, :project_access => project_a})
      end
      @projects_permissions[project.id]
    end

    def retrieve_project_permissions project_id
      begin
        result = GitlabHttp.new("projects/#{project_id}/members",authtoken).retrieve(self.id)
      rescue => _
        result = {:access_level => 0}
      end
      GitlabPermission.new result
    end

    private

    def retrieve_projects

      projects = []
      begin
        page = 1

        result = []

        stop = false

        until stop
          curesult = GitlabHttp.new('projects',authtoken).retrieve(nil,{:query => {:order_by => 'id',:page => page, :per_page => 50}})
          if curesult.length == 0
            stop = true
          else
            result += curesult
            page += 1
          end
        end

        projects = result.map do |rp|
          Gitlab::GitlabProject.new(rp)
        end

      rescue HttpExceptions::RequestException => _
        []
      end

      projects

    end

  end
end
