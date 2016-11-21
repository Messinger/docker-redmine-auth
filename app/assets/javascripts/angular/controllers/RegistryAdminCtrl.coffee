@registryadmin.controller 'RegistryAdminCtrl', [
  "$scope",
  "registrydataService",
  "registryloginService",
  "$q",
  "$location"
  ($scope,registrydataService,registryloginService,$q,$location) ->

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
              authRequired = true
              $location.path('/login')
        )
        if (!scopeDestroyed)
          $scope.$emit("$stateReadyToShow")
      updatestatusmessage()

]
