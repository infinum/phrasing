if Phrasing.log == true
  logger_class = defined?(ActiveSupport::Logger) ? ActiveSupport::Logger::SimpleFormatter : Logger::SimpleFormatter
  
  logger_class.class_eval do
        alias_method :old_call, :call
        def call(severity, timestamp, progname, msg)
           old_call(severity, timestamp, progname, msg) unless msg.include? "phrasing"
        end
  end
end