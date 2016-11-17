require 'redmine_http'
require 'redmine/redmine_role'
require 'redmine/redmine_project'

module Redmine
  class RedmineMembership  < PresentationModel

    def project
      @project ||= gen_project
    end

    def roles
      @roles ||= gen_roles
    end

    def extra_hash options = {}
      {:project => project.to_hash(options), :roles => roles.map {|item| item.to_hash(options)} }
    end

    def repository_write_role? user
      ! roles.find{|x| x.repository_write_role?(user)}.nil?
    end

    def repository_read_role? user
      ! roles.find{|x| x.repository_read_role?(user)}.nil?
    end

    private

    def gen_project
      RedmineProject.new(data[:project])
    end

    def gen_roles
      return [] if data[:roles].blank?
      data[:roles].map {|item| RedmineRole.new(item)}
    end
  end
end
