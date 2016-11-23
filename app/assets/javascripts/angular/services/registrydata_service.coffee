@registryadmin.service('registrydataService',[
  "registrytokenService"
  '$http'
  "$rootScope"
  "$q"
  (registrytokenService,$http,$rootScope,$q) ->
    headers = {
      "Accept": "application/json",
    }

    dockerapi = docker_admin_host+'/v2'

    action = (method,url,params = {}, data = null ,extraheader,constructor = null) ->
      deferred = $q.defer()
      urlParts = url.split('#')

      counter = 0
      beartoken = undefined
      headers = angular.merge({},headers,extraheader)

      _u = dockerapi+urlParts[0]
      config = {
        method: method
        params: params
        url: _u
      }

      unless data == null
        config['data'] = JSON.stringify(data)

      doaction = () ->
        if beartoken != undefined
          headers['X-Authorization']="Bearer #{beartoken}"
        config['headers'] = headers
        http_result = $http(config)
        http_result.then(
          (response) ->
            deferred.resolve(response)
          (response) ->
            if response == undefined || response.data == null
              res = {
                error: {message: "Unknown"}
                status: 0
              }
              deferred.reject(res)
            else
              if counter == 0 && $rootScope.globals != undefined && $rootScope.globals.currentUser != undefined
                counter++
                AuthHeader = response.headers()['www-authenticate']
                registrytokenService.create_token(AuthHeader).then(
                  (response) ->
                    beartoken = response
                    unless beartoken == undefined
                      beartoken = beartoken.token
                    doaction()
                )
              else
                res = {
                  error: response.data["errors"][0]
                  status: response.status
                  headers: response.headers()
                }
                console.log res
                deferred.reject(res)
        )
      doaction()
      deferred.promise

    get = (url,extraheader = {}, constructor = null, params = {} ) ->
      action('GET',url,params,null,extraheader,constructor)


    {
      get: get
    }
])
