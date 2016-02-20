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

  private

  def gen_permissions
    return [] if data['permissions'].blank?
    data['permissions'].map {|item| item.to_sym}
  end

end