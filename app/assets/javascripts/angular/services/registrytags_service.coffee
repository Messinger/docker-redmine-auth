@registryadmin.service('registrytagsService',[
  "registrydataService"
  "$http"
  "$q"
  (registrydataService,$http, $q) ->

    listTags = (repository,beartoken,start,max) ->
      deferred = $q.defer()
      if max > 0
        _p = {n: max, last: start}
      else
        _p = null
      tags = registrydataService.get(beartoken,"/#{repository}/tags/list",_p)
      tags.then(
        (response) ->
          _list = response.data
          deferred.resolve(_list)
      )
      deferred.promise

    listManifests = (repository,tagordigest,beartoken,start,max) ->
      deferred = $q.defer()
      if max > 0
        _p = {n: max, last: start}
      else
        _p = null

      manifests = registrydataService.get(beartoken,"/#{repository}/manifests/#{tagordigest}",_p,{Accept: "application/vnd.docker.distribution.manifest.v2+json"})
      manifests.then(
        (response) ->
          _list = response.data
          _digest = response.headers('docker-content-digest')

          deferred.resolve({digest: _digest, data: _list})
      )
      deferred.promise

    {
      listTags: listTags
      listManifests: listManifests
    }
])

