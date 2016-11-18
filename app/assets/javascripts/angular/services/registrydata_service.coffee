@registryadmin.service('registrydataService',[
  '$http',
  "$q",
  ($http,$q) ->
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
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
          console.log response.statusText
          response.statusText
      )

    {
      get: get
    }
])
