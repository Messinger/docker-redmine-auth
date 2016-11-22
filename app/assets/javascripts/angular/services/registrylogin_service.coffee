@registryadmin.service('registryloginService',[
  "Base64"
  "registrydataService"
  "registrytokenService"
  "$http"
  "$cookies"
  "$rootScope"
  "$q"
  (Base64,registrydataService,registrytokenService,$http, $cookies, $rootScope, $q) ->

    getLoginStatus = () ->
      deferred = $q.defer()

      counter = 0
      token = undefined
      _head = {}

      docheck = () ->
        if token != undefined
          _head['Authorization']="Basic #{token}"
        registrydataService.get('/',_head).then(
          (response) ->
            deferred.resolve(response)
          (response) ->
            if response == undefined || response.data == null
              res = {
                error: {message: "Unknown"}
                status: 0
              }
            else
              if counter == 0 && $rootScope.globals != undefined && $rootScope.globals.currentUser != undefined
                counter++
                AuthHeader = response.headers()['www-authenticate']
                token = registrytokenService.create_token(AuthHeader)
                docheck()
              else
                res = {
                  error: response.data["errors"][0]
                  status: response.status
                  headers: response.headers()
                }
                console.log res
                deferred.reject(res)
        )
      docheck()
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
