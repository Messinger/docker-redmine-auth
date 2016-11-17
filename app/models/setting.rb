# Model holding all settings defined in settings.yml
# noinspection RubyClassVariableUsageInspection
class Setting < ActiveRecord::Base

  PASSWORD_DISPLAY_HOLDER = "*********"

  @@available_settings = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
  
  
  validates_uniqueness_of :name
  validates_inclusion_of :name, :in => @@available_settings.keys
  validates_numericality_of :value, :only_integer => true, :if => Proc.new { |setting| @@available_settings[setting.name]['format'] == 'int' }

  # Hash used to cache setting values
  @cached_settings = {}
  @cached_cleared_on = Time.now

  # retrieve a value for a specific key
  # it looks at the settigns.yml and convert the content to the type set there
  # * *Types*:
  #   - string 
  #   - int  convert content to integer (or 0 if not correct)
  #   - symbol convert content to a ruby symbol
  def value
    v = read_attribute(:value)
    # Unserialize serialized settings
    v = YAML::load(v) if (@@available_settings[name]['format'] == 'list' || @@available_settings[name]['serialized']) && v.is_a?(String)
    v = v.to_sym if @@available_settings[name]['format'] == 'symbol' && !v.blank?
    v = v.to_i if @@available_settings[name]['format'] == 'int' && !v.blank?
    v = v.to_bool if @@available_settings[name]['format'] == 'bool' && !v.blank?
    v
  end

  # set a new value to a key
  # values are always stored as strings inside database
  def value=(v)
    v = v.to_yaml if v && @@available_settings[name] && @@available_settings[name]['serialized']
    write_attribute(:value, v.to_s)
  end

  # Returns the value of the setting named name
  def self.[](name)
    v = @cached_settings[name]
    v ? v : (@cached_settings[name] = find_or_default(name).value)
  end

  # set the value of setting named name
  def self.[]=(name, v)
    setting = find_or_default(name)
    setting.value = (v ? v : "")
    @cached_settings[name] = nil
    setting.save
    setting.value
  end

  # Defines getter and setter for each setting
  # Then setting values can be read using: Setting.some_setting_name
  # or set using Setting.some_setting_name = "some value"
  @@available_settings.each do |name, params|
    src = <<-END_SRC
    def self.#{name}
      self[:#{name}]
    end

    def self.#{name}?
      self[:#{name}].to_i > 0
    end

    def self.#{name}=(value)
      self[:#{name}] = value
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end
    # Clears the settings cache
  def self.clear_cache
    @cached_settings.clear
    @cached_cleared_on = Time.now
    logger.info "Settings cache cleared." if logger
  end

private
  # Returns the Setting instance for the setting named name
  # (record found in database or new record with default value)
  def self.find_or_default(name)
    name = name.to_s
    raise "There's no setting named #{name}" unless @@available_settings.has_key?(name)
    setting = find_by_name(name)
    unless setting
      setting = new(:name => name)
      setting.value = @@available_settings[name]['default']
    end
    setting
  end
end
