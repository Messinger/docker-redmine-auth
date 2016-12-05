require 'api_mapper_http'

class RegistryAdminController < ApplicationController

  def index
  end

  def api_mapper
    _method = request.method_symbol
    _headers = request.headers
    _auth = _headers['X-Authorization']
    _path = "#{Setting.docker_admin_host}/v2/#{params[:apiaction]}"
    _pars = params.to_hash.symbolize_keys!
    _pars.delete(:controller)
    _pars.delete(:action)
    _pars.delete(:apiaction)

    debug _pars

    _h,_r = ApiMapperHttp.new(_method,_path,{:authtoken => _auth},_pars, {'Accept' => _headers[:accept]}).doaction

    _rheaders = _h.headers.as_json.merge(response.headers)

    debug response.headers.inspect
    debug _h.headers.as_json

    #ignore_headers = %w[content-length]
    #response.headers.merge!(_h.as_json)

    response.headers.merge!(_rheaders)
    response.headers.delete('content-length')
    debug response.headers.inspect

    if _r.nil?
      render :nothing => true, :status => _h.code, :content_type => _h.headers['content-type']
    else
      render :json => _r, :status => _h.code, :content_type => _h.headers['content-type']
    end
  end

  def auth_mapper
    _p = params[:params]
    _uri = params[:url]
    auth = {:authtoken => "Basic #{params[:authtoken]}"}

    debug(params)

    _h,_r = ApiMapperHttp.new(:get,_uri,auth,_p, {'Accept' => 'application/json'}).doaction

    render :json => _r, :status => _h.code, :content_type => _h.headers['content-type']

  end

end
