#= require jquery
#= require jquery_ujs
#= require jquery.mailcheck.min
#= require html.min.js
#= require mailcheck
#= require marked
#= require validation
#= require search
#= require dropdown
#
#= require tag_autocomplete
#= require reviews/reviews
#= require reviews/votes
#= require reviews/comments

keyEsc = 27

# Clear any sort of popup on escape keypress
clearPopups = (e) ->
  if (e.which || e.keyCode) == keyEsc
    $("[data-popup=true]:visible").hide()


# Unescape a string HTML entities
# Ex:
#
#   htmlDecode("&lt;?php hello() &gt;")
#   => "<?php hello() >"
#
window.htmlDecode = (value) -> $.trim $('<div>').html(value).text()


$ ->
  document.addEventListener('keydown', clearPopups, false)
