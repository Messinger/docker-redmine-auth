require 'httparty'
require 'rest_exceptions'
require 'kuxdo'

# simple wrapper for httparty, in this project we just need GET aka find
class RedmineHttp
  include HTTParty
  include RestExceptions
  extend Kuxdo

  STANDARD_HEADER = {'Accept' => 'application/json','Content-Type' => 'application/json; charset=UTF-8'}

  # debug_output $stdout
  no_follow(true)
  base_uri Setting.redmine_url

  def initialize(resource_uri, authentication={username: nil, password: nil })
    raise(ArgumentError, "Authentication not a Hash") unless authentication.is_a?(Hash)
    raise(ArgumentError, "Resource_uri not a String") unless resource_uri.is_a?(String)

    @logger = Kuxdo::getlogger("#{self.class.logger_name}")

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
    _resource_uri = "/" + resource_uri unless resource_uri[0,1] == "/"
    @resource_uri = _resource_uri
    @element = resource_uri
  end

  # get on a single item if id set, otherwise a list
  # result is always a hash or array of hashes this moment
  def find id,options = {}
    _result = retrieve id,options
    _key = if id.blank?
             @element
           else
             @element.singularize
           end
    _result[_key] unless _result.blank?
  end

  def count options = {}
    _result = retrieve nil,options.merge({:limit => 1, :offset => 0})

    if _result.nil? || _result['total_count'].blank?
      0
    else
      _result['total_count'].to_i
    end

  end

  def retrieve id,options = {}
    options.merge!({:headers => STANDARD_HEADER })
    if @auth.key? :username
      options[:basic_auth] = @auth
    end

    begin
      if id.blank?
        _id = '.json'
      else
        _id = "/#{id}.json"
      end
      response = self.class.get("#{@resource_uri}#{_id}" , options)
    rescue HTTParty::RedirectionTooDeep => e
      error e
      response = e
    rescue => e
      error e
      raise e
    end
    if !response.nil? && response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end


end
