require 'utils/attributes_accessor'
require 'redmine_http'

class RedmineRole  < PresentationModel
  @@redmine_role_elements = %w[ id name inherited:bool ]

  include AttributesAccessor

  def permissions
    @permissions ||= gen_permissions
  end

  def extra_hash
    {:permissions => permissions}
  end

  def retrieve_permissions! user
    _p = RedmineHttp.new('roles',user.auth).find(self.id)
    if !_p.nil?
      _p = RedmineRole.new({:data => _p})
      @permissions = _p.permissions unless _p.blank?
      permissions
    else
      nil
    end
  end

  def repository_write_role? user
    if @permissions.blank?
      retrieve_permissions! user
    end
    false if @permissions.blank?
    @permissions.include? :commit_access
  end

  def repository_read_role? user
    if @permissions.blank?
      retrieve_permissions! user
    end
    false if @permissions.blank?
    @permissions.include? :browse_repository
  end

  private

  def gen_permissions
    return [] if data['permissions'].blank?
    data['permissions'].map {|item| item.to_sym}
  end

end