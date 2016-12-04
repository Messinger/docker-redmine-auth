"use strict"

@registryadmin.factory 'Base64', () ->
  encode = (input) ->
    btoa(input)
  decode = (input) ->
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "")
    atob(input)

  {
    encode: encode
    decode: decode
  }
