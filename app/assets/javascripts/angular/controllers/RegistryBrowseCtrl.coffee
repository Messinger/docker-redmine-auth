initialRequest = true

@registryadmin.controller 'RegistryBrowseCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "registrytokenService"
  "$q"
  "$state"
  "$stateParams"
  "$rootScope"
  "mainService"
  ($scope,registrydataService,registryloginService,registrytokenService,$q,$state,$stateParams,$rootScope,mainService) ->

      scopeDestroyed = false
      authRequired = false
      $scope.statusmessage = ""


      if mainService.isLoggedIn()
        authRequired = false

      $scope.$on('$stateLoggedout', (event) ->
        updatestatusmessage()
      )

      updatestatusmessage = () ->
        val = registryloginService.getLoginStatus()
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
                $state.go("login")
        )
      updatestatusmessage()
]
