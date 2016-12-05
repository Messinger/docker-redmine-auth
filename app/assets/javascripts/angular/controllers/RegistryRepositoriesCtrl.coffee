@registryadmin.controller 'RegistryRepositoriesCtrl', [
  "$scope"
  "registrydataService"
  "repositoriesService"
  "$q"
  ($scope,registrydataService,repositoriesService,$q) ->

    getlist = () ->
      deferred = $q.defer()
      _head = {}


    $scope.repositories = ""
    $scope.liststart = 0
    $scope.listmax = 0

    buildList = () ->
      _r = repositoriesService.getRepositories($scope.liststart,$scope.listmax)
      _r.then(
        (repositories) ->
          $scope.repositories = repositories['repositories']
        (errors) ->
          $scope.repositories = null
          console.log errors
          $scope.repositories = null
    )

    $scope.$on('$stateReadyToShow', (event) ->
      buildList()
    )

    $scope.buildList = buildList

]
