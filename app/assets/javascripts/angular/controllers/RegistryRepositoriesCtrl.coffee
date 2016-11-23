@registryadmin.controller 'RegistryRepositoriesCtrl', [
  "$scope"
  "registrydataService"
  "repositoriesService"
  "$location"
  "$q"
  ($scope,registrydataService,repositoriesService,$location,$q) ->

    getlist = () ->
      deferred = $q.defer()
      _head = {}


    $scope.repositories = ""
    $scope.beartoken = undefined
    $scope.liststart = 0
    $scope.listmax = 0

    $scope.$on('$stateReadyToShow', (event) ->
      _r = repositoriesService.getRepositories($scope.beartoken,$scope.liststart,$scope.listmax)
      _r.then(
        (repositories) ->
          $scope.repositories = repositories['repositories']
        (errors) ->
          console.log errors

      )
    )

    $scope.goRepo = (repo) ->
      console.log repo
      $location.path("/repository").search({repo: repo})
]
