@registryadmin.controller 'RegistryAdminCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "$q"
  "$location"
  "$rootScope"
  ($scope,registrydataService,registryloginService,$q,$location,$rootScope) ->

      initialRequest = true
      scopeDestroyed = false
      authRequired = false
      $scope.statusmessage = ""

      updatestatusmessage = () ->
        val = registryloginService.getLoginStatus()
        val.then(
          (result) ->
            $scope.statusmessage = result
            authRequired = false
            if initialRequest
              initialRequest = false
          (result) ->

            $scope.statusmessage = result['error'].message
            if result['status'] == 401
              unless result.header == undefined
                AuthHeader = result.headers['www-authenticate'] #['Www-Authenticate']
                console.log AuthHeader
                $rootScope.bearer = AuthHeader
              authRequired = true
              $location.path('/login')
        )
        if (!scopeDestroyed)
          $scope.$emit("$stateReadyToShow")
      updatestatusmessage()

]
