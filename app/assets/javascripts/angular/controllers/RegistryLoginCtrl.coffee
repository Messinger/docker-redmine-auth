
@registryadmin.controller 'RegistryLoginCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "$q"
  "$location"
  ($scope,registrydataService,registryloginService,$q,$location) ->
    scopeDestroyed = false

    registryloginService.clearCredentials()
    $scope.error = ''

    $scope.login = () ->
      registryloginService.setCredentials($scope.username, $scope.password)
      $location.path('/')

#      val = registryloginService.getLoginStatus()

#      val.then(
#        (result) ->
#          $scope.statusmessage = result
#          $location.path('/')
#        (result) ->
#          if result == undefined || result['status'] == 401
#            authRequired = true
#            $location.path('/login')
#      )


]
