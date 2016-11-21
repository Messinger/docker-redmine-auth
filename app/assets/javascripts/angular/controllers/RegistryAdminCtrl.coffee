@registryadmin.controller 'RegistryAdminCtrl', [
  "$scope",
  "registrydataService",
  "registrystatusService",
  "$q",
  "$location"
  ($scope,registrydataService,registrystatusService,$q,$location) ->

      initialRequest = true
      scopeDestroyed = false
      authRequired = false
      $scope.statusmessage = ""

      updatestatusmessage = () ->
        val = registrystatusService.getLoginStatus()
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
