
class DockerUser

  def initialize login,authuser = []
    @authuser = authuser
    @login = login
  end

  def add_authentication auth
    @authuser << auth
  end

  def can_read? identifier
    @authuser.each do |user|
      pr = user.find_project_by_identifier identifier
      if !pr.nil? && user.can_read?(pr)
        return true
      end
    end
    false
  end

  def can_write? identifier
    @authuser.each do |user|
      pr = user.find_project_by_identifier identifier
      if !pr.nil? && user.can_write?(pr)
        return true
      end
    end
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