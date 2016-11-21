@registryadmin.service('registrydataService',[
  '$http',
  "$q",
  ($http,$q) ->
    headers = {
      "Accept": "application/json",
    }

    dockerapi = "http://localhost:5000/v2"

    get = (url,constructor = null, params = {} ) ->
      urlParts = url.split('#')
      config = {
        headers: headers
        params: params
      }

      $http.get(dockerapi+urlParts[0],config).then(
        (response) ->
          response.data
        (response) ->
#          AuthHeader = response.headers('Www-Authenticate')
#          console.log AuthHeader
          response
      )

    {
      get: get
    }
])
