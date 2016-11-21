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

    response.headers.merge!(_rheaders)

    render :json => _r, :status => _h.code, :content_type => _h.headers['content-type']
  end

end
