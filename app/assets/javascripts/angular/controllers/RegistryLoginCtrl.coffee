
@registryadmin.controller 'RegistryLoginCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "$q"
  "$state"
  "$stateParams"
  "$rootScope"
  ($scope,registrydataService,registryloginService,$q,$state,$stateParams,$rootScope) ->

    $scope.error = ''

    $scope.login = () ->
      registryloginService.clearCredentials()
      registryloginService.setCredentials($scope.username, $scope.password)
      $state.go("registryOverview")
#      $rootScope.loginback = undefined
#      $location.path(back) unless back == undefined

    $scope.logout = () ->
      registryloginService.clearCredentials()
      $rootScope.$broadcast('$stateLoggedout')
      $state.go("registryOverview")
]
