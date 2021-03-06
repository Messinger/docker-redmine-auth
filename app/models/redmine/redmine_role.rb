require 'redmine_http'

module Redmine
  class RedmineRole  < PresentationModel

    def permissions
      unless to_h.key?(:permissions)
        _p = gen_permissions
        send('permissions=',_p)
      end
      self[:permissions]
    end

    def extra_hash options = {}
      {:permissions => permissions}
    end

    def retrieve_permissions! user
      _p = RedmineHttp.new('roles',user.auth).find(self.id)
      if !_p.nil?
        _p = RedmineRole.new(_p)
        send('permissions=',_p.permissions.map {|p| p.to_sym } ) unless _p.blank?
        @permissions = _p.permissions.map {|p| p.to_sym }  unless _p.blank?
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
end
