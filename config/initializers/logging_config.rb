
Rails.configuration().after_initialize do

  loggerconfig = "#{Rails.root}/config/logging.yml"

  if (File.exists? loggerconfig)
    Logging.logger['Rails'].debug("Initialize Logger for #{Rails.env}")
    begin
      Logging::Config::YamlConfigurator.load(loggerconfig,Rails.env)
      Logging.logger['Rails'].debug("Logger changed logging configuration")
        if Rails.configuration().show_log_configuration and (STDIN.tty? or defined?(Rails::Console))
          ::Logging.show_configuration(STDERR)
        end
    rescue StandardError
      Logging.logger['Rails'].warn("#{$!}")
    end
  else
    Logging.logger['Rails'].warn("Logger config #{loggerconfig} not found!")
  end

  ### begin extra logging stuff
  
  # Nothing yet

  ### end   extra logging stuff  

end
