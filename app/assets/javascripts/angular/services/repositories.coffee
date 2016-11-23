@registryadmin.service('repositoriesService',[
  "registrydataService"
  "$http"
  "$rootScope"
  "$q"
  (registrydataService,$http, $rootScope, $q) ->

    getRepositories = (beartoken,start,max) ->
      deferred = $q.defer()
      if max > 0
        _p = {n: max, last: start}
      else
        _p = null
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
