require 'utils/attributes_accessor'

module Gitlab
  class GitlabProject  < PresentationModel
    @@class_attributes_elements = %w[ id visibility_level name name_with_namespace path path_with_namespace ]

    include AttributesAccessor


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

    private
    
    def gen_safe_path
      path_with_namespace.split('/').map { |s| s.parameterize }.join('/')
    end

    def gen_safe_name
      name_with_namespace.split('/').map { |s| s.parameterize }.join('/')
    end
  end
end
