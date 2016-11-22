
@registryadmin.controller 'RegistryLoginCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "$q"
  "$location"
  "$rootScope"
  ($scope,registrydataService,registryloginService,$q,$location,$rootScope) ->
    scopeDestroyed = false

    registryloginService.clearCredentials()
    $scope.error = ''

    $scope.login = () ->
      registryloginService.setCredentials($scope.username, $scope.password)
      back = $rootScope.loginback
      $rootScope.loginback = undefined
      $location.path(back)

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
