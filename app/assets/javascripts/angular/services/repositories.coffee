@registryadmin.service('repositoriesService',[
  "registrydataService"
  "registrytokenService"
  "$rootScope"
  "$q"
  (registrydataService,registrytokenService, $rootScope, $q) ->

    getRepositories = (start,max) ->
      deferred = $q.defer()
      if max > 0
        _p = {n: max, last: start}
      else
        _p = null

      beartoken = registrytokenService.getToken("/_catalog")

      registries = registrydataService.get(beartoken,'/_catalog',_p)
      registries.then(
        (response) ->
          _list = response.data
          deferred.resolve(_list)
      )
      deferred.promise

    {
      getRepositories: getRepositories
    }

])
