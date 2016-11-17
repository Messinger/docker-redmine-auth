module Gitlab
  class GitlabProject  < PresentationModel

    def safe_name_with_namespace
      @safe_name_with_namespace ||= gen_safe_name
    end

    def safe_name
      @safe_name ||= name.parameterize
    end

    def safe_path_with_namespace
      @safe_path_with_namespace ||= gen_safe_path
    end

    def safe_path
      @safe_path ||= path.parameterize
    end

    def retrieve_permissions user
      begin
        res = GitlabHttp.new("projects/#{self.id}/members",user.authtoken).retrieve user.id
        OpenStruct.new(res)
      rescue => ex
        {}
      end
    end

    private
    
    def gen_safe_path
      path_with_namespace.split('/').map { |s| s.parameterize }.join('/')
    end

    def gen_safe_name
      name_with_namespace.split('/').map { |s| s.parameterize }.join('/')
    end
  end
end
