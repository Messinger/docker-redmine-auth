@registryadmin.controller 'RegistryRepositoryCtrl', [
  "$scope"
  "registrydataService"
  "repositoriesService"
  "$location"
  "$state"
  "$stateParams"
  "$q"
  ($scope,registrydataService,repositoriesService,$location,$state,$stateParams,$q) ->

    if $stateParams.repository == ""
      $state.go("registryOverview")
    $scope.repository = $stateParams.repository

]
