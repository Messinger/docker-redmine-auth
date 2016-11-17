
class DockerUser

  def initialize login,authuser = []
    @authuser = authuser
    @login = login
  end

  def add_authentication auth
    @authuser << auth
  end

  def can_read? identifier
    false
  end

  def can_write? identifier
    false
  end

  def api_key
    if @authuser.length > 0
      @authuser[0].api_key
    else
      ''
    end
  end

  def login
    @login
  end

end