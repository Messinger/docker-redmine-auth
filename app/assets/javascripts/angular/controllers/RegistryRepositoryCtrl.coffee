@registryadmin.controller 'RegistryRepositoryCtrl', [
  "$scope"
  "registrydataService"
  "repositoriesService"
  "$location"
  "$q"
  ($scope,registrydataService,repositoriesService,$location,$q) ->

    console.log $location.search()
    $scope.repository = $location.search()['repo']

]
