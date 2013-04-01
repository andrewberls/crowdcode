# Get the rid of the current review
rid = -> $('.review').data('rid')

vote = (dir) ->
  $votes = $('.votes-container').find('.votes')
  count  = parseInt($votes.html())
  if dir == 'up'
    $votes.html(count+1)
  else
    $votes.html(count-1)
  $.post "/reviews/#{rid()}/votes", { dir: dir }

$ ->
  activeClass = 'vote-active'

  # TODO: clean this up


  # TODO: if you undo a vote, it sends a downvote to neutralize,
  # but then the view grabs the last downvote record and displays it

  $('.vote-up').click ->
    if $(@).hasClass(activeClass)
      # Undo an upvote
      vote('down')
      $(@).removeClass(activeClass)
    else
      # Add an upvote
      vote('up')
      $('.vote').removeClass(activeClass)
      $(@).addClass(activeClass)
    return false


  $('.vote-down').click ->
    if $(@).hasClass(activeClass)
      # Undo a downvote
      vote('up')
      $(@).removeClass(activeClass)
    else
      # Add a downvote
      vote('down')
      $('.vote').removeClass(activeClass)
      $(@).addClass(activeClass)
    return false
