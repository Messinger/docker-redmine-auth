require 'http_exceptions'
require 'kuxdo'

# Module defining exceptions raised by RSys RestApi
#
# Base for all exceptions is class RequestException
#
module RestExceptions
  # Mark an error in rest backend with Radisys
  #
  class RestException < HttpExceptions::RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] The error message which replaces the default message
    def initialize(message = nil, response_code)
      super("RestException", message, response_code)
    end
  end
  
  class RestNotFoundException < RestException
    def initialize(message)
      super(message||I18n.t('exceptions.not_found'), :not_found)
    end
  end

  class RestUnauthorizedException < RestException
    def initialize(message, rest_params)
      super(message||I18n.t('exceptions.unauthorized'),:unauthorized)
    end
  end

  class RestForbiddenException < RestException
    def initialize(message, rest_params)
      super(message||I18n.t('exceptions.forbidden'),:forbidden)
    end
  end

  class RestUnprocessableException < RestException
    def initialize(message, rest_params)
      super(message,:unprocessable_entity)
    end
  end

  class RestConflictException < RestException
    def initialize(message, rest_params)
      super(message,:conflict)
    end
  end

  class RestBadRequestException < RestException
    def initialize(message, rest_params)
      super(message,:bad_request)
    end
  end

  class RestServerErrorException < RestException
    def initialize(message, rest_params)
      super(message,500)
    end
  end

  class RestServiceUnavailableException < RestException
    def initialize(message, rest_params)
      super(message,503)
    end
  end

  module_function

  def raise_rest(message,status_code)
    case status_code
      when 409
        raise RestConflictException.new message
      when 422
        raise RestUnprocessableException.new message
      when 401
        raise RestUnauthorizedException.new message
      when 404
        raise RestNotFoundException.new message
      when 403
        raise RestForbiddenException.new message
      when 400
        raise RestBadRequestException.new message
      when 500
        raise RestServerErrorException.new message
      when 503
        raise RestServiceUnavailableException.new message
      else
        raise RestException.new message,status_code
    end

  end

end
