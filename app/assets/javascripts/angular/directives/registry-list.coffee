@registryadmin.directive("registryList",[
  () ->
    {
      templateUrl: "templates/partials/registry-list.html"
      scope: true
      link: (scope,el,attr) ->
        angular.extend(scope, scope.$eval(attrs.registryList))
    }
  ]
)
