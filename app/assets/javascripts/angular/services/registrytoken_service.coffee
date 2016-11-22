@registryadmin.service('registrytokenService',[
  '$http'
  "$q"
  "$rootScope"
  ($http,$q,$rootScope) ->
    headers = {
      "Accept": "application/json"
      "X-Requested-With": 'XMLHttpRequest'
    }


    create_token = (bearer) ->

      deferred = $q.defer()
      authtoken = $rootScope.globals.currentUser.authdata
      _h = angular.merge({},headers,{
        Authorization:authtoken
      })
      _h['X-Requested-With']='XMLHttpRequest'

      bear = bearer.split('realm=')
      bres = bear[1].split(",")
      _uri = bres[0].replace(/^["]+|["]+$/g,"")
      params = bres[1]

      $http.get(_uri,{headers:_h}).then(
        (response) ->
          deferred.resolve(response)
        (response) ->
          deferred.reject(response)
      )
      deferred.promise

    {
      create_token: create_token
    }
])