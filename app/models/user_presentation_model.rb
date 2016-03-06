class UserPresentationModel < PresentationModel


  def self.login _username, _password
    raise NotImplementedError.new
  end

  def can_write? _project
    raise NotImplementedError.new
  end

  def can_read? _project
    raise NotImplementedError.new
  end

  def can_catalog?
    raise NotImplementedError.new
  end

end
