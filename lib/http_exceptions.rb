
# Module defining some exceptions which may rendered to html status
#
# Base for all exceptions is class RequestException
#
# for now following exceptions are implemented:
# * HttpExceptions::BadRequest
# * HttpExceptions::NotFound
# * HttpExceptions::Unauthorized
# * HttpExceptions::ForbiddenRequest
# * HttpExceptions::NotAcceptable
# * HttpExceptions::RequestTimedout
# * HttpExceptions::UnsupportedMediatype
# * HttpExceptions::UnprocessableException
# * HttpExceptions::GoneException
module HttpExceptions

  # Base class for generating html exceptions
  class RequestException < StandardError

    # Initializes the exception
    # This should only called from child class initializers
    #
    # == Args
    # [default] the default message if no one is given by caller
    # [message] a message which may replace the default one
    # [code] the rails HTML status code assigned to this exception like :bad_request etc.
    #
    # == Examples
    #   raise BadRequest.new("The parameter #{p} is absolutly wrong")
    #   raise BadRequest
    def initialize(default="ok",message=nil,code)
      if (message == nil)
        @errormsg = default
      else
        @errormsg = message
      end
      @errorcode = code
    end

    # Returns the assigned html status code
    def code
      @errorcode
    end

    # Returns the assigned html status message
    def message
      @errormsg
    end

  end

  # Mark that the current request isn't known or not correct
  #
  # == HTTP status codes
  # <tt>400</tt>
  class BadRequest < RequestException

    # Initialize the Exception
    #
    # == Args
    # [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.bad_request'),message,:bad_request
    end

  end

  # Mark that the current request is not authorized
  #
  # == HTTP status codes
  # <tt>401</tt>
  class Unauthorized < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.unauthorized'),message,:unauthorized
    end
  end

  # Mark that the current request is forbidden
  #
  # == HTTP status codes
  # <tt>403</tt>
  class ForbiddenRequest < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.forbidden'),message,:forbidden
    end
  end

  # Mark that the current request couldn't find data
  #
  # == HTTP status codes
  # <tt>404</tt>
  class NotFound < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t("exceptions.not_found"),message,:not_found
    end
  end

  # Mark that the current request is not acceptable
  #
  # == HTTP status codes
  # <tt>406</tt>
  class NotAcceptable < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.not_acceptable'),message,:not_acceptable
    end
  end

  # Mark that the current request is not processable
  #
  # == HTTP status codes
  # <tt>422</tt>
  class UnprocessableException < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.unprocessable'),message,:unprocessable_entity
    end
  end

  # Mark that the current resource is not longer available
  #
  # == HTTP status codes
  # <tt>410</tt>
  class GoneException < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.gone'),message,:gone
    end
  end

  # Mark that the current request timed out
  #
  # == HTTP status codes
  # <tt>408</tt>
  class RequestTimedout < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.timeout'),message,:request_timeout
    end
  end

  # Request asks for unsupported Media
  #
  # == HTTP status codes
  # <tt>415</tt>
  class UnsupportedMediatype < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.unsupported_media'),message,:unsupported_media_type
    end
  end

  class ServerError < RequestException
    # Initialize the Exception
    #
    # * *Args*
    #   [message] A message which replaces the default message
    def initialize(message = nil)
      super I18n.t('exceptions.server_error'),message,:internal_server_error
    end
  end
  
end
