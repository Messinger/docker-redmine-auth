
@registryadmin.controller 'RegistryLoginCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "$q"
  "$location"
  "$rootScope"
  ($scope,registrydataService,registryloginService,$q,$location,$rootScope) ->
    scopeDestroyed = false

    $scope.error = ''

    $scope.login = () ->
      registryloginService.clearCredentials()
      registryloginService.setCredentials($scope.username, $scope.password)
      back = $rootScope.loginback
      $rootScope.loginback = undefined
      $location.path(back) unless back == undefined

    $scope.logout = () ->
      registryloginService.clearCredentials()
      $rootScope.$broadcast('$stateLoggedout')
]
