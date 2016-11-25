@registryadmin.directive("repositoriesList",[
  () ->
    {
      templateUrl: "views/partials/repositories-list.html"
      scope: true
      link: (scope,el,attr) ->
        angular.extend(scope, scope.$eval(attr.repositoriesList))
    }
  ]
)
