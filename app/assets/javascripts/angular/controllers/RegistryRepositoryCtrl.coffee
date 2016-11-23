@registryadmin.controller 'RegistryRepositoryCtrl', [
  "$scope"
  "registrydataService"
  "repositoriesService"
  "$q"
  ($scope,registrydataService,repositoriesService,$q) ->

    getlist = () ->
      deferred = $q.defer()
      _head = {}


    $scope.repositories = ""
    $scope.beartoken = undefined

    $scope.$on('$stateReadyToShow', (event) ->
      console.log "May get list"
      _r = repositoriesService.getRepositories($scope.beartoken)
      _r.then(
        (repositories) ->
          console.log repositories
          $scope.repositories = repositories
        (errors) ->
          console.log errors

      )
    )

]
