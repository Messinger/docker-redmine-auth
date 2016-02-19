# encoding: utf-8

# module defining some extra Logging classes and methods
#
# Best is using it as Mixin into your class
#
# == Methods 
# * debug
# * info
# * warn
# * error
# * fatal
#
# == Parameter for each method
# [message] the message itself (required)
# [logger] an alternative loggername (string), if nil, default logger is used
module Kuxdo
  
  @@methods = %w[debug info warn error fatal]
  
  @@methods.each do |name|
    src = <<-END_SRC
    # logging method
    def #{name}(message,logger=nil)
      if logger == nil
        if (defined? @logger)
          @logger.#{name} message
        else
          Logging.logger.root.#{name} message
        end
      else
        Logging.logger[logger].#{name} message
      end
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end
  
  class AdminLogger
    %w[debug info warn error fatal].each do |name|
      src = <<-END_SRC
      def #{name}(task,action,message)
        Logging.ndc.push task unless task.blank?
        Logging.ndc.push action unless action.blank?
        # message may be empty
        if Thread.current[:adminlogger].blank?
          Logging.logger.root.#{name} message
        else
          Thread.current[:adminlogger].#{name} message 
        end 
        Logging.ndc.pop unless action.blank?
        Logging.ndc.pop unless task.blank?
      end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end
  end
  
  module_function
  # Get a logger instance for specific sublogger
  # == Parameter
  # loggername:: name of Logger to use, may something like <tt>"Ngccs"</tt> or <tt>"Ngccs::ApplicationController"</tt>
  # == Returns
  # a Loggerinstance to use with Kuxdo
  def getlogger(loggername);Logging.logger[loggername] end
  
  def level_to_name(level)
    return "disabled" if level > 4 || level < 0
    @@methods[level]
  end    
end
