@registryadmin.controller 'RegistryRepositoryCtrl', [
  "$scope"
  "registrydataService"
  "registrytagsService"
  "$location"
  "$state"
  "$stateParams"
  "$q"
  ($scope,registrydataService,registrytagsService,$location,$state,$stateParams,$q) ->

    if $stateParams.repository == ""
      $state.go("registryOverview")
    $scope.repository = $stateParams.repository

    listTags = () ->
      tags = registrytagsService.listTags($scope.repository,undefined,0,0)
      tags.then(
        (tags) ->
          $scope.tags = tags['tags']
        (errors) ->
          console.log errors

      )

    listTags()

]
