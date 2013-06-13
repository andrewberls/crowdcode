#= require jquery
#= require jquery_ujs
#= require jquery.mailcheck.min
#= require html.min.js
#= require validation
#= require search
#= require dropdown

keyEsc = 27

# Clear any sort of popup on escape keypress
clearPopups = (e) ->
  if (event.which || event.keyCode) == keyEsc
    $("[data-popup=true]:visible").each (i, el) -> $(el).hide()


$ ->
  document.addEventListener('keydown', clearPopups, false)
