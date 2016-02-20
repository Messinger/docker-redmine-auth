require 'utils/attributes_accessor'
require 'redmine_http'
require 'redmine_role'

class RedmineMembership  < PresentationModel
  @@redmine_membership_elements = %w[ id:int ]

  include AttributesAccessor

  def project
    @project ||= gen_project
  end

  def roles
    @roles ||= gen_roles
  end

  def extra_hash
    {:project => project.to_hash, :roles => roles.map {|item| item.to_hash} }
  end

  private

  def gen_project
    RedmineProject.new({:data => data['project']})
  end

  def gen_roles
    return [] if data['roles'].blank?
    data['roles'].map {|item| RedmineRole.new({:data => item})}
  end
end