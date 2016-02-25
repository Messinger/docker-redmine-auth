require 'utils/attributes_accessor'
require 'redmine_http'

module Redmine
  class RedmineProject < PresentationModel
    @@class_attributes_elements = %w[ id:int name identifier description created_on updated_on is_public:bool ]

    include AttributesAccessor

    def self.find_by_identifier identifier,user

      _p = RedmineHttp.new('projects',user.auth).find(identifier)
      if !_p.nil?
        RedmineProject.new({:data => _p})
      else
        nil
      end

    end
  end
end