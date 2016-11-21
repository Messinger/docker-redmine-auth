@registryadmin.service('registrystatusService',[
  "registrydataService",
  "$http",
  "$q",
  (registrydataService,$http,$q) ->

    getLoginStatus = () ->
      deferred = $q.defer()

      registrydataService.get('/').then(
        (response) ->
          deferred.resolve(response)
        (response) ->
          res = {
            error: response.data["errors"][0]
            status: response.status
          }
          deferred.reject(
            res
          )
      )
      deferred.promise

    {
      getLoginStatus: getLoginStatus
    }

  ])
