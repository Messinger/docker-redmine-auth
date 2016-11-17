require 'redmine_http'

module Redmine
  class RedmineProject < PresentationModel

    def self.find_by_identifier identifier,user

      _p = RedmineHttp.new('projects',user.auth).find(identifier)
      if !_p.nil?
        RedmineProject.new(_p)
      else
        nil
      end

    end
  end
end