@registryadmin.service('registrydataService',[
  "registrytokenService"
  '$http'
  "$rootScope"
  "csrfTokenService"
  "$q"
  (registrytokenService,$http,$rootScope,csrfTokenService,$q) ->
    standardheaders = {
      "Accept": "application/json"
      "X-CSRF-Token": csrfTokenService
    }

    _loc = window.location.protocol+"//"+window.location.host
    if window.docker_admin_host == _loc
      auth_key = "Authorization"
    else
      auth_key = "X-Authorization"

    dockerapi = '/v2'

    action = (beartoken, method,url,params = {} ,extraheader = {}, data = null,constructor = null) ->
      deferred = $q.defer()
      urlParts = url.split('#')

      counter = 0
      headers = angular.merge({},standardheaders,extraheader)

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
          headers[auth_key]="Bearer #{beartoken}"
        else
          delete headers[auth_key]

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
              if counter == 0 && $rootScope.globals != undefined && $rootScope.globals.currentUser != undefined && response.status == 401
                counter++
                AuthHeader = response.headers()['www-authenticate']
                registrytokenService.create_token(AuthHeader).then(
                  (response) ->
                    _token = response
                    unless _token == undefined
                      beartoken = _token.token
                      registrytokenService.setToken(urlParts[0],beartoken)
                    doaction()
                )
              else
                res = {
                  error: response.statusText
                  status: response.status
                  headers: response.headers()
                }
                deferred.reject(res)
        )
      doaction()
      deferred.promise

    get = (scope,url, params = {}, extraheader = {}, constructor = null ) ->
      action(scope,'GET',url,params,extraheader,null,constructor)

    head = (scope,url, params = {}, extraheader = {}, constructor = null ) ->
      action(scope,'HEAD',url,params,extraheader,null,constructor)

    del = (scope,url,params = {}, extraheader = {} ) ->
      action(scope,'DELETE',url,params,extraheader,null, null)


    {
      get: get
      head: head
      del: del
    }
])
