@registryadmin.controller 'RegistryRepositoryCtrl', [
  "$scope"
  "registrydataService"
  "registrytagsService"
  "mainService"
  "modalService"
  "$state"
  "$stateParams"
  "$q"
  ($scope,registrydataService,registrytagsService,mainService,modalService,$state,$stateParams,$q) ->

    if $stateParams.repository == ""
      $state.go("registryOverview")

    if mainService.isLoggedIn()
      authRequired = false

    $scope.repository = $stateParams.repository

    $scope.manifests = undefined
    $scope.manifests_errors = undefined
    $scope.tagserrors = undefined
    $scope.tags = undefined

    listTags = () ->
      tags = registrytagsService.listTags($scope.repository,0,0)
      tags.then(
        (tags) ->
          $scope.tags = tags['tags']
          $scope.tagserrors = undefined
        (errors) ->
          $scope.tags = undefined
          $scope.tagserrors = errors
          console.log errors
      )

    listTags()

    listManifests = (tag) ->
      tags = registrytagsService.listManifests($scope.repository,tag,0,0)
      $scope.selected_tag = null

      tags.then(
        (tags) ->
          $scope.manifests = tags
          $scope.selected_tag = tag
          $scope.manifests_errors = undefined
        (errors) ->
          $scope.manifests = undefined
          $scope.manifests_errors = errors
          console.log errors
      )

    $scope.listManifests = listManifests

    $scope.prettyDump = (manifests) ->
      JSON.stringify(manifests,null,'  ')

    $scope.askDelete = (event,name, tag, digest) ->
      event.stopPropagation()
      console.log event
      console.log "#{$scope.repository}:#{tag}"
      console.log digest
      modalService.openConfirm(
        {
          title: "Delete TAG #{$scope.selected_tag}"
          text: "Realy delete this tag"
          confirm: "Delete"
          data: {
            text: {
              tag: tag
            }
          }
        }
      ).then(
        (confirmed) ->
          if confirmed
            console.log "ja, löschen"
            registrytagsService.deleteManifest($scope.repository,digest).then(
              (result) ->
                $scope.manifests = undefined
                listTags()
            )
          else
            console.log "nein, doch nicht"
      )
]
