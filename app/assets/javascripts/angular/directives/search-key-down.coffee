@registryadmin.directive("searchKeyDown",[
  () ->
    (scope,element,attrs) ->
      element.bind("keyup", (event) ->
        scope.$apply( () ->
          scope.$eval(attrs.searchKeyDown)
        )
        #event.preventDefault()
      )
])

@registryadmin.directive("searchEnterPressed",[
  () ->
    (scope,element,attrs) ->
      element.bind("keyup", (event) ->
        if event.keyCode == 13
          scope.$apply( () ->
            scope.$eval(attrs.searchEnterPressed)
          )
          event.preventDefault()
      )
])
