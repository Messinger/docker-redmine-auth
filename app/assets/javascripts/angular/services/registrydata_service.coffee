@registryadmin.service('registrydataService',[
  '$http',
  "$q",
  ($http,$q) ->
    headers = {
      "Accept": "application/json",
    }

    dockerapi = docker_admin_host+'/v2'

    get = (url,constructor = null, params = {} ) ->
      urlParts = url.split('#')
      config = {
        headers: headers
        params: params
      }

      $http.get(dockerapi+urlParts[0],config).then(
        (response) ->
          response.data
      )

    {
      get: get
    }
])
