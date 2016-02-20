require 'utils/attributes_accessor'

class RedmineUser < PresentationModel
  @@redmine_user_elements = %w[ id login firstname lastname mail created_on last_login api_key memberships groups auth ]

  include AttributesAccessor

  def self.login _username, _password
    auth = {:username => _username, :password => _password}
    blah = HTTParty.get("#{Setting.redmine_url}/users/current.json?include=memberships,groups",:basic_auth => auth)

    if !blah.nil? && blah.code == 200
      _u = JSON.parse(blah.body)['user']
      _u['auth'] = auth
      _user = RedmineUser.new({:data => _u})
      _user
    else
      nil
    end

  end
end
