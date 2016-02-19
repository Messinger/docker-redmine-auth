require "kuxdo"
require 'http_exceptions'
require 'rest_exceptions'

class ApplicationController < ActionController::Base
  include Kuxdo
  include HttpExceptions
  include RestExceptions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session


  def initialize
    @logger = getlogger("Ngccs::ApplicationController::#{self.class.logger_name}")
    super
  end

  rescue_from RequestException do |exception|
    warn("Catched RequestException #{exception}")
    exception_request exception
  end

private

  def log_exception exception
    error exception.message
    exception.backtrace.each { |line| error line }
  end

  def exception_request ex
    log_exception ex
    error_request ex.code, ex.message
  end

  def error_request errorcode,msg = nil
    begin
      code_number = Rack::Utils::status_code(errorcode)
      debug "Print error code #{code_number}"
      respond_to do |format|
        format.html {
          fname = "shared/#{code_number}"
          if not template_exists?(fname)
            fname = "shared/404"
          end
          @errormsg = msg
          render :file => fname, :status => errorcode
        }
        format.xml  {
          ex = Exception.new
          ex.code = errorcode
          ex.message = message
          render :xml => ex, :status => errorcode
        }
        format.json {
          render :plain => msg, status: errorcode, :content_type => 'text/plain'
        }
        format.any  { head errorcode }
      end
    rescue
      render text: "#{msg}", status: errorcode
    end
  end

end
