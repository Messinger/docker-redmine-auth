@registryadmin.service('registryloginService',[
  "Base64"
  "registrydataService"
  "registrytokenService"
  "$http"
  "$cookies"
  "$rootScope"
  "$q"
  (Base64,registrydataService,registrytokenService,$http, $cookies, $rootScope, $q) ->

    getLoginStatus = (beartoken) ->
      deferred = $q.defer()

      _head = {}

      beartoken = registrytokenService.getToken("/")

      docheck = () ->
        registrydataService.get(beartoken,'/').then(
          (response) ->
            deferred.resolve(response)
          (response) ->
            if response == undefined || response.data == null
              res = {
                error: {message: "Unknown"}
                status: 0
              }
            else
              res = response
            deferred.reject(res)
        )
      docheck()
      deferred.promise

    clearCredentials = () ->
      $rootScope.globals = undefined
      $rootScope.tokens = {}
      $cookies.remove('dockeradmin')

    setCredentials = (user,password) ->
      authdata = Base64.encode(user + ':' + password)
      $rootScope.globals = {
        tokens: {}
        currentUser: {
          username: user
          authdata: authdata
        }
      }
      $cookies.putObject('dockeradmin', $rootScope.globals)

    loggedIn = () ->
      true

    {
      getLoginStatus: getLoginStatus
      clearCredentials: clearCredentials
      setCredentials: setCredentials
      login: setCredentials
      loggedIn: loggedIn
    }

  ])
