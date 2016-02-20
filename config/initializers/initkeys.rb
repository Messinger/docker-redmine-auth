if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)
  key_pem = File.read Setting.ssl_private_key_file
  $ssl_key = OpenSSL::PKey::RSA.new key_pem

  if defined?(PhusionPassenger)
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      if forked
        key_pem = File.read Setting.ssl_private_key_file
        $ssl_key = OpenSSL::PKey::RSA.new key_pem
      end
    end
  end
end
