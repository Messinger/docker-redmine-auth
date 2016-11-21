@registryadmin.service('registryloginService',[
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
          if response == undefined || response.data == null
            res = {
              error: {message: "Unknown"}
              status: 0
            }
          else
            res = {
              error: response.data["errors"][0]
              status: response.status
              headers: response.headers()
            }
          deferred.reject(
            res
          )
      )
      deferred.promise

    clearCredentials = () ->
      $rootScope.globals = {}
      $cookies.remove('dockeradmin')
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
      $cookies.put('dockeradmin', $rootScope.globals)

    {
      getLoginStatus: getLoginStatus
      clearCredentials: clearCredentials
      setCredentials: setCredentials
      login: setCredentials
    }

  ])
