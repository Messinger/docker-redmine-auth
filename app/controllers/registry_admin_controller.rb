class RegistryAdminController < ApplicationController

  def index
  end

  def api_mapper
    _method = request.method_symbol
    _headers = request.headers

    render :json => 'done'
  end

end
