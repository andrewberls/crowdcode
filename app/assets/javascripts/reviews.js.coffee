# Get the rid of the current review
rid = -> $('.review').data('rid')

post_vote = (dir) ->
  $votes = $('.votes-container').find('.votes')
  count = parseInt($votes.html())
  if dir == 'up'
    $votes.html(count+1)
  else
    $votes.html(count-1)
  $.post "/reviews/#{rid()}/votes", { dir: dir }
  return false

$ ->
  disabled_class = 'vote-disabled'
  $('.vote-up').click ->
    post_vote('up') unless $(@).hasClass(disabled_class)
    $(@).addClass(disabled_class)

  $('.vote-down').click ->
    post_vote('down') unless $(@).hasClass(disabled_class)
    $(@).addClass(disabled_class)
