require 'utils/attributes_accessor'
require 'redmine_http'

class RedmineProject < PresentationModel
  @@redmine_project_elements = %w[ id:int name identifier description created_on updated_on is_public ]

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
