@registryadmin.controller 'RegistryRepositoriesCtrl', [
  "$scope"
  "registrydataService"
  "repositoriesService"
  "registrytagsService"
  "$q"
  ($scope,registrydataService,repositoriesService,registrytagsService,$q) ->

    getlist = () ->
      deferred = $q.defer()
      _head = {}


    $scope.repositories = ""
    $scope.liststart = 0
    $scope.listmax = 0

    buildList = () ->
      $scope.search_error = null
      _r = repositoriesService.getRepositories($scope.liststart,$scope.listmax)
      _r.then(
        (repositories) ->
          $scope.repositories = repositories['repositories']
        (errors) ->
          $scope.repositories = null
          console.log errors
          $scope.search_error = "Registry catalog failed, registry gaved: #{errors['error']}"
          $scope.repositories = []

    )

    $scope.$on('$stateReadyToShow', (event) ->
      buildList()
    )

    $scope.buildList = buildList

    $scope.searchval = ''
    $scope.search_error = null

    $scope.searchRepository = () ->
      console.log "Search ... #{$scope.searchval}"
      tags = registrytagsService.listTags($scope.searchval,0,0)
      tags.then(
        (success) ->
          $scope.search_error = null
          $scope.repositories = [$scope.searchval]
        (error) ->
          console.log error
          $scope.search_error = "Repository status failed, registry said '#{error['error']}'"
          $scope.repositories = []
      )

]
