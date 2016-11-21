@registryadmin.service('registrystatusService',[
  "Base64"
  "registrydataService"
  "$http"
  "$cookies"
  "$rootScope"
  "$q"
  (Base64,registrydataService,$http, $cookies, $rootScope, $q) ->

    getLoginStatus = () ->
      deferred = $q.defer()

      registrydataService.get('/').then(
        (response) ->
          deferred.resolve(response)
        (response) ->
          res = {
            error: response.data["errors"][0]
            status: response.status
          }
          deferred.reject(
            res
          )
      )
      deferred.promise

    clearCredentials = () ->
      $rootScope.globals = {}
      $cookies.remove('globals')
      $http.defaults.headers.common.Authorization = 'Basic '


    setCredentials = (user,password) ->
      authdata = Base64.encode(user + ':' + password)
      $rootScope.globals = {
        currentUser: {
          username: user
          authdata: authdata
        }
      }
      $http.defaults.headers.common['Authorization'] = "Basic #{authdata}"
      $cookies.put('globals', $rootScope.globals)

    {
      getLoginStatus: getLoginStatus
      clearCredentials: clearCredentials
      setCredentials: setCredentials
    }

  ])
