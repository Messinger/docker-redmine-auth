class @Repository

  constructor: (@_name) ->
  valid: () ->
    @_name != undefined
  getName: () ->
    @_name
  setName: (@_name) ->

class @Repositories

  constructor: (@_repositories = {}) ->

  getRepositories: () -> @_repositories
  setRepositories: (@_repositories = {}) ->