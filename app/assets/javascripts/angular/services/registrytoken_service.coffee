@registryadmin.service('registrytokenService',[
  "csrfTokenService"
  '$http'
  "$q"
  "$rootScope"
  (csrfTokenService,$http,$q,$rootScope) ->
    headers = {
      "Accept": "application/json"
      "X-Requested-With": 'XMLHttpRequest'
      "X-CSRF-Token": csrfTokenService
    }

    _loc = window.location.protocol+"//"+window.location.host

    clearTokens = () ->
      $rootScope.tokens = {}

    setToken = (url,token) ->
      if $rootScope.tokens == undefined
        $rootScope.tokens = {}
      $rootScope.tokens[url] = token

    getToken = (url) ->
      if $rootScope.tokens == undefined
        undefined
      else
        $rootScope.tokens[url]

    bearer_to_parts = (bearer) ->
      #'Bearer realm="http://localhost:3000/auth.json",service="Docker registry'

      _base = bearer.replace('Bearer realm=','')
      console.log _base
      parts = _base.split(',')
      console.log parts
      url = parts[0].replace(/^["]+|["]+$/g,"")
      console.log url
      params = {}
      parts = parts.slice(1)

      for _p in parts
        kv = _p.split('=')
        params[kv[0]] = kv[1].replace(/^["]+|["]+$/g,"")

      {url: url,params: params}

    create_token = (bearer) ->

      deferred = $q.defer()
      authtoken = $rootScope.globals.currentUser.authdata

      bear = bearer_to_parts(bearer)


      if bear['url'].startsWith(_loc)
        _h = angular.merge({},headers,{
          Authorization:"Basic #{authtoken}"
        })
        _h['X-Requested-With']='XMLHttpRequest'

        http_result = $http({
          method: 'GET'
          url: bear['url']
          headers:_h
          params: bear['params']
        })
      else
        _h = angular.merge({},headers,{
          })
        _h['X-Requested-With']='XMLHttpRequest'
        data = JSON.stringify({url: bear['url'],params: bear['params'],authtoken: authtoken})
        http_result = $http({
          method:'POST'
          url: '/auth_mapper'
          data: data
          headers:_h
          })
      http_result.then(
        (response) ->
          deferred.resolve(response.data)
        (response) ->
          deferred.reject(response)
      )
      deferred.promise

    {
      create_token: create_token
      bearer_to_parts: bearer_to_parts
      setToken: setToken
      getToken: getToken
      clearTokens:clearTokens
    }
])
