require 'httparty'
require 'rest_exceptions'
require 'kuxdo'

# simple wrapper for httparty, in this project we just need GET aka find
class ApiMapperHttp
  include HTTParty
  include RestExceptions
  extend Kuxdo

  #debug_output $stdout
  no_follow(true)
  base_uri ''

  def initialize method,actionurl,auth = {}, parameters = {},headers = {},data = {}

    @method = method
    @actionurl = actionurl||''
    @parameters = parameters
    @headers = headers
    @data = data
    @resource_uri = "#{@actionurl}"
    @auth = auth

    unless Setting.rest_proxy_host.blank?
      proxy_port = Setting.rest_proxy_port.blank? ? nil : Setting.rest_proxy_port
      self.class.http_proxy(Setting.rest_proxy_host, proxy_port)
    end

  end

  def doaction options={}

    options.merge!({:headers => @headers,:query => @parameters})
    unless @data.blank?
      options.merge!({:body => @data.to_json})
    end

    unless @auth.blank?
      if @auth.key?(:authtoken) && !@auth[:authtoken].blank?
        options[:headers][:Authorization] = @auth[:authtoken]
      end
    end

    response = self.class.send(@method,@resource_uri,options)

    if response.headers['content-type'].start_with?('application/json')
      resbody = JSON.parse(response.body)
    else
      resbody = response.body
    end
    return response,resbody

  end

end
