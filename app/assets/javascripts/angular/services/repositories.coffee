@registryadmin.service('repositoriesService',[
  "registrydataService"
  "$http"
  "$rootScope"
  "$q"
  (registrydataService,$http, $rootScope, $q) ->

    getRepositories = (beartoken) ->
      deferred = $q.defer()
      registries = registrydataService.get(beartoken,'/_catalog')
      registries.then(
        (response) ->
          _list = response.data['repositories']
          deferred.resolve(_list)
      )
      deferred.promise

    {
      getRepositories: getRepositories
    }

])
