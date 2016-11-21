@registryadmin.controller 'RegistryAdminCtrl', [
  "$scope",
  "registrydataService",
  "registrystatusService",
  "$q",
  ($scope,registrydataService,registrystatusService,$q) ->

      initialRequest = true
      scopeDestroyed = false
      authRequired = false
      $scope.statusmessage = ""

      updatestatusmessage = () ->
        val = registrystatusService.getLoginStatus()
        val.then(
          (result) ->
            $scope.statusmessage = result
            if initialRequest
              initialRequest = false
          (result) ->
            $scope.statusmessage = result['error'].message
            if result['status'] == 401
              authRequired = true
        )
        if (!scopeDestroyed)
          $scope.$emit("$stateReadyToShow")
      updatestatusmessage()


]
