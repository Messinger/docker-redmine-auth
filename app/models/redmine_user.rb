require 'utils/attributes_accessor'
require 'redmine_http'

class RedmineUser < PresentationModel
  @@redmine_user_elements = %w[ id login firstname lastname mail created_on last_login api_key memberships groups auth ]

  include AttributesAccessor

  def self.login _username, _password
    auth = {:username => _username, :password => _password}
    blah = RedmineHttp.new('users',auth).find(:current)

    if !blah.nil?
      _u = blah['user']
      _u['auth'] = auth
      _user = RedmineUser.new({:data => _u})
      _user
    else
      nil
    end

  end
end
