require 'httparty'
require 'rest_exceptions'
require 'kuxdo'


class GitlabHttp
  include HTTParty
  include RestExceptions
  extend Kuxdo

  STANDARD_HEADER = {'Accept' => 'application/json','Content-Type' => 'application/json; charset=UTF-8'}
  APIPATH = '/api/v3'

  #debug_output $stdout
  no_follow(true)
  base_uri Setting.gitlab_url

  def initialize(resource_uri, authentication={username: nil, password: nil, accesstoken: nil })
    raise(ArgumentError, "Authentication not a Hash") unless authentication.is_a?(Hash)
    raise(ArgumentError, "Resource_uri not a String") unless resource_uri.is_a?(String)

    @logger = Kuxdo::getlogger("#{self.class.logger_name}")

    unless Setting.rest_proxy_host.blank?
      proxy_port = Setting.rest_proxy_port.blank? ? nil : Setting.rest_proxy_port
      self.class.http_proxy(Setting.rest_proxy_host, proxy_port)
    end
    @auth = authentication
    @headers = STANDARD_HEADER

    unless authentication[:accesstoken].blank?
      @headers.merge!({:"PRIVATE-TOKEN" => authentication[:accesstoken]})
    end

    _resource_uri = "/" + resource_uri unless resource_uri[0,1] == "/"
    @resource_uri = "#{APIPATH}#{_resource_uri}"
    @element = resource_uri

  end

  def create data={},options = {}
    options.merge!({:headers => STANDARD_HEADER, :body => data.to_json })

    begin
      response = self.class.post(@resource_uri,options)
    rescue HTTParty::RedirectionTooDeep => e
      error es
s
      response = nil
    rescue => e
      error e
      raise e
    end


    result = JSON.parse(response.body)

    if response.code > 399
      raise_rest result[:message],response.code
    end

    result

  end

  def retrieve id = nil,options = {}
    options.merge!({:headers => @headers })

    if id.blank?
      _id = ''
    else
      _id = "/#{id}"
    end

    begin
      response = self.class.get("#{@resource_uri}#{_id}",options)
    rescue HTTParty::RedirectionTooDeep => e
      error e
      response = nil
    rescue => e
      error e
      raise e
    end

    result = JSON.parse(response.body)
    if response.code > 399
      raise_rest result[:message],response.code
    end

    result

  end

end
