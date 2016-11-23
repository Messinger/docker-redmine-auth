@registryadmin.controller 'RegistryAdminCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "registrytokenService"
  "$q"
  "$location"
  "$rootScope"
  ($scope,registrydataService,registryloginService,registrytokenService,$q,$location,$rootScope) ->

      initialRequest = true
      scopeDestroyed = false
      authRequired = false
      $scope.statusmessage = ""
      roottoken = undefined

      updatestatusmessage = () ->
        val = registryloginService.getLoginStatus(roottoken)
        val.then(
          (result) ->
            $scope.statusmessage = "Access granted"
            $rootScope.$broadcast('$stateReadyToShow')
            authRequired = false
            if initialRequest
              initialRequest = false
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
