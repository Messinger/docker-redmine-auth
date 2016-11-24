@registryadmin.controller 'RegistryRepositoryCtrl', [
  "$scope"
  "registrydataService"
  "registrytagsService"
  "mainService"
  "$state"
  "$stateParams"
  "$q"
  ($scope,registrydataService,registrytagsService,mainService,$state,$stateParams,$q) ->

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

    listManifests = (tag) ->
      tags = registrytagsService.listManifests($scope.repository,tag,undefined,0,0)
      tags.then(
        (tags) ->
          $scope.manifests = tags
        (errors) ->
          console.log errors
      )

    $scope.listManifests = listManifests
]
