require 'redmine_http'
require 'redmine/redmine_membership'
require 'http_exceptions'
require 'user_presentation_model'

module Redmine
  class RedmineUser < UserPresentationModel

    def self.login _username, _password
      auth = {:username => _username, :password => _password}
      _u = RedmineHttp.new('users',auth).find(:current,{:query => {:include=>'memberships'}})

      if !_u.nil?
        if _u['api_key'].blank?
          _u['auth'] = auth
        else
          _u['auth'] = {:apitoken => _u['api_key']}
        end
        RedmineUser.new(_u)
      else
        raise HttpExceptions::Unauthorized.new
      end

    end

    def memberships
      @memberships ||= gen_memberships
    end

    def extra_hash options = {}
      {:memberships => memberships.map {|item| item.to_hash(options) }}
    end

    # ensure that project is kind of RedmineProject
    def can_write? _project
      return true if Setting.admin_users.include? self.login
      _m = find_memberships_by_project _project
      return false if _m.blank?
      !_m.find{|x| x.repository_write_role?(self)}.blank?
    end

    # ensure that project is kind of RedmineProject
    def can_read? _project
      return true if Setting.admin_users.include? self.login

      _m = find_memberships_by_project _project
      return false if _m.blank?
      !_m.find{|x| x.repository_read_role?(self)}.blank?
    end

    def find_membership_by_project _project
      memberships.find{|x| x.project.id == _project.id} unless _project.blank?
    end

    def find_memberships_by_project _project
      memberships.select{|x| x.project.id == _project.id} unless _project.blank?
    end

    def find_project_by_identifier _identifier
      Redmine::RedmineProject.find_by_identifier _identifier, self
    end

    private

    def gen_memberships
      _ms = data[:memberships]
      return [] if _ms.blank?
      _ms.map do |item|
        RedmineMembership.new(item )
      end
    end
  end
end
