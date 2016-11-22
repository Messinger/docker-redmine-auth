require 'api_mapper_http'

class RegistryAdminController < ApplicationController

  def index
  end

  def api_mapper
    _method = request.method_symbol
    _headers = request.headers
    _path = params[:apiaction]


    _h,_r = ApiMapperHttp.new(_method,_path,params,{'Accept' => 'application/json'}).doaction

    _rheaders = _h.headers.as_json.merge(response.headers)

    debug response.headers.inspect
    debug _h.headers.as_json

    #ignore_headers = %w[content-length]
    #response.headers.merge!(_h.as_json)

    response.headers.merge!(_rheaders)
    response.headers.delete('content-length')
    debug response.headers.inspect

    render :json => _r, :status => _h.code, :content_type => _h.headers['content-type']
  end

end
