initialRequest = true

@registryadmin.controller 'RegistryAdminCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "registrytokenService"
  "$q"
  "$location"
  "$rootScope"
  "$cookies"
  ($scope,registrydataService,registryloginService,registrytokenService,$q,$location,$rootScope,$cookies) ->

      scopeDestroyed = false
      authRequired = false
      $scope.statusmessage = ""
      roottoken = undefined
      $scope.loggedIn = false
      if initialRequest
        initialRequest = false
        globaldata = $cookies.getObject('dockeradmin')
        if $rootScope.globals == undefined && globaldata != undefined
          $rootScope.globals = globaldata

      if $rootScope.globals != undefined  && $rootScope.globals.currentUser != undefined
        $scope.loggedIn = true && authRequired == false

      $scope.$on('$stateLoggedout', (event) ->
        $scope.loggedIn = false
        updatestatusmessage()
      )

      updatestatusmessage = () ->
        val = registryloginService.getLoginStatus(roottoken)
        val.then(
          (result) ->
            $scope.statusmessage = "Access granted"
            $rootScope.$broadcast('$stateReadyToShow')
            authRequired = false

          (result) ->
            $scope.statusmessage = result['error'].message
            if result['status'] == 401
              authRequired = true
              $rootScope.loginback = '/'
              if $rootScope.globals == undefined || $rootScope.globals.currentUser == undefined
                $location.path('/login')

        )
      updatestatusmessage()

]
