
@registryadmin.controller 'RegistryLoginCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "mainService"
  "$q"
  "$state"
  "$stateParams"
  "$rootScope"
  ($scope,registrydataService,registryloginService,mainService,$q,$state,$stateParams,$rootScope) ->

    $scope.error = ''

    $scope.login = () ->
      registryloginService.clearCredentials()
      registryloginService.setCredentials($scope.username, $scope.password)
      $state.go("registryOverview")

    $scope.logout = () ->
      registryloginService.clearCredentials()
      $rootScope.$broadcast('$stateLoggedout')
      $rootScope.loggedIn = false
      $state.go("registryOverview")

]
