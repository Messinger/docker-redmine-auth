@registryadmin.service('registrytagsService',[
  "registrydataService"
  "registrytokenService"
  "$q"
  (registrydataService,registrytokenService, $q) ->

    listTags = (repository,start,max) ->
      deferred = $q.defer()
      if max > 0
        _p = {n: max, last: start}
      else
        _p = null
      uri = "/#{repository}/tags/list"
      beartoken = registrytokenService.getToken("read #{repository}")
      tags = registrydataService.get(beartoken,uri,_p)
      tags.then(
        (response) ->
          registrytokenService.setToken("read #{repository}",registrytokenService.getToken(uri))
          _list = response.data
          deferred.resolve(_list)
      )
      deferred.promise

    listManifests = (repository,tagordigest,start,max) ->
      deferred = $q.defer()
      if max > 0
        _p = {n: max, last: start}
      else
        _p = null
      beartoken = registrytokenService.getToken("read #{repository}")
      manifests = registrydataService.get(beartoken,"/#{repository}/manifests/#{tagordigest}",_p,{Accept: "application/vnd.docker.distribution.manifest.v2+json"})
      manifests.then(
        (response) ->
          _list = response.data
          _digest = response.headers('docker-content-digest')

          deferred.resolve({digest: _digest, data: _list})
        (error) ->
          deferred.reject(error)
      )
      deferred.promise

    {
      listTags: listTags
      listManifests: listManifests
    }
])

