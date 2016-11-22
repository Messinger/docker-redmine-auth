@registryadmin.service('registrytokenService',[
  '$http'
  "$q"
  "$rootScope"
  ($http,$q,$rootScope) ->
    headers = {
      "Accept": "application/json"
      "X-Requested-With": 'XMLHttpRequest'
    }


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
      _h = angular.merge({},headers,{
        Authorization:authtoken
      })
      _h['X-Requested-With']='XMLHttpRequest'

      bear = bearer_to_parts(bearer)

      $http.get(bear['url'],{headers:_h,params: bear['params']}).then(
        (response) ->
          deferred.resolve(response)
        (response) ->
          deferred.reject(response)
      )
      deferred.promise

    {
      create_token: create_token
      bearer_to_parts: bearer_to_parts
    }
])