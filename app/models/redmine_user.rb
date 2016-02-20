require 'utils/attributes_accessor'
require 'redmine_http'
require 'redmine_membership'

class RedmineUser < PresentationModel
  @@redmine_user_elements = %w[ id:int login firstname lastname mail created_on last_login api_key groups auth ]

  include AttributesAccessor

  def self.login _username, _password
    auth = {:username => _username, :password => _password}
    _u = RedmineHttp.new('users',auth).find(:current,{:query => {:include=>'memberships'}})

    if !_u.nil?
      _u['auth'] = auth
      RedmineUser.new({:data => _u})
    else
      nil
    end

  end

  def memberships
    @memberships ||= gen_memberships
  end

  def extra_hash
    {:memberships => memberships.map {|item| item.to_hash }}
  end

  def can_write? _project
    _m = find_membership_by_project _project
    return false if _m.blank?
    _m.repository_write_role? self
  end

  def can_read? _project
    _m = find_membership_by_project _project
    return false if _m.blank?
    _m.repository_read_role? self
  end

  def find_membership_by_project _project
    memberships.find{|x| x.project.id == _project.id} unless _project.blank?
  end

  private

  def gen_memberships
    _ms = data['memberships']
    return [] if _ms.blank?
    _ms.map do |item|
      RedmineMembership.new({:data => item })
    end
  end
end
