require 'httparty'

class RedmineHttp
  include HTTParty
  include RestExceptions
  extend Kuxdo

  STANDARD_HEADER = {'Accept' => 'application/json','Content-Type' => 'application/json; charset=UTF-8'}

  no_follow(true)
  base_uri Setting.redmine_url

  debug_output $stdout

  def initialize(resource_uri, authentication={username: nil, password: nil })
    raise(ArgumentError, "Authentication not a Hash") unless authentication.is_a?(Hash)
    raise(ArgumentError, "Resource_uri not a String") unless resource_uri.is_a?(String)

    unless Setting.rest_proxy_host.blank?
      proxy_port = Setting.rest_proxy_port.blank? ? nil : Setting.rest_proxy_port
      self.class.http_proxy(Setting.rest_proxy_host, proxy_port)
    end
    @auth = {}

    if ! authentication[:apitoken].blank?
      @auth = authentication
    else
      unless authentication[:username].blank?
        @auth = {:username => authentication[:username]}
        @auth[:password] = authentication[:password]
      end
    end
    resource_uri = "/" + resource_uri unless resource_uri[0,1] == "/"
    @resource_uri = resource_uri
  end

  def find id,options = {}
    options.merge!({:headers => STANDARD_HEADER })
    if @auth.key? :username
      options[:basic_auth] = @auth
    end

    begin
      response = self.class.get(@resource_uri + "/#{id}.json" , options)
    rescue HTTParty::RedirectionTooDeep => e
      response = e.respone
    rescue => e
      raise e
    end
    if !response.nil? && response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end

end
