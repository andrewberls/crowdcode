# Get the rid of the current review
rid = -> $('.review').data('rid')

# POST a vote (direction and amount)
vote = (dir, amt=1) ->
  $.post "/reviews/#{rid()}/votes", { dir: dir, amt: amt }

# Change the display of the vote counter
changeCounter = (dir, amt=1) ->
  $votes = $('.votes-container').find('.votes')
  count  = parseInt($votes.html())
  if dir == 'up'
    $votes.html(count + amt)
  else
    $votes.html(count - amt)



$ ->
  $up   = $('.vote-up')
  $down = $('.vote-down')
  activeClass = 'vote-active'

  # TODO: clean this up

  $up.click ->
    if $(@).hasClass(activeClass)
      # Undo an upvote (Up -> Up = None)
      vote('up')
      changeCounter('down')
      $(@).removeClass(activeClass)
    else
      if $down.hasClass(activeClass)
        # Switch (Down -> Up)
        vote('up', 2)
        changeCounter('up', 2)
      else
        # Add (None -> Up)
        vote('up')
        changeCounter('up')

      $('.vote').removeClass(activeClass)
      $(@).addClass(activeClass)
    return false


  $down.click ->
    if $(@).hasClass(activeClass)
      # Undo a downvote (Down -> Down = None)
      vote('down')
      changeCounter('up')
      $(@).removeClass(activeClass)
    else
      if $up.hasClass(activeClass)
        # Switch (Up -> Down)
        vote('down', 2)
        changeCounter('down', 2)
      else
        # Add (None -> Down)
        vote('down')
        changeCounter('down')

      $('.vote').removeClass(activeClass)
      $(@).addClass(activeClass)
    return false
