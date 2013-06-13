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
  if (e.which || e.keyCode) == keyEsc
    $("[data-popup=true]:visible").hide()


window.htmlDecode = (value) -> $.trim $('<div>').html(value).text()


$ ->
  document.addEventListener('keydown', clearPopups, false)
