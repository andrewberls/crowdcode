# Get the rid of the current review
rid = -> $('.review').data('rid')

vote = (dir, amt=1) ->
  $.post "/reviews/#{rid()}/votes", { dir: dir, amt: amt }

changeCounter = (dir, amt=1) ->
  # TODO: check if voting or just taking back
  $votes = $('.votes-container').find('.votes')
  # count  = parseInt($votes.data('count'))
  count  = parseInt($votes.html())
  console.log("old count: #{count}")
  # TODO: it's a difference of 1 from the ORIGINAL value
  # e.g, if at 1 and we vote up and then down, we should be at 0
  if dir == 'up'
    $votes.html(count + amt)
  else
    $votes.html(count - amt)



$ ->
  $up   = $('.vote-up')
  $down = $('.vote-down')
  activeClass = 'vote-active'


  # undo (up->up) isn't working because its sending an active downvote?

  $up.click ->
    if $(@).hasClass(activeClass)
      # Undo an upvote (Up -> Up = None)
      console.log "up -> up = undo (vote down)"
      vote('down')
      changeCounter('down')
      $(@).removeClass(activeClass)
    else
      if $down.hasClass(activeClass)
        # Switch (Down -> Up)
        console.log "down -> up, vote up by 2"
        vote('up', 2)
        changeCounter('up', 2)
      else
        # Add (None -> Up)
        console.log "none -> up, vote up by 1"
        vote('up')
        changeCounter('up')

      $('.vote').removeClass(activeClass)
      $(@).addClass(activeClass)
    return false


  $down.click ->
    if $(@).hasClass(activeClass)
      # Undo a downvote (Down -> Down = None)
      console.log "down -> down = undo (vote up)"
      vote('up')
      changeCounter('up')
      $(@).removeClass(activeClass)
    else
      if $up.hasClass(activeClass)
        # Switch (Up -> Down)
        console.log "up -> down, vote down by 2"
        vote('down', 2)
        changeCounter('down', 2)
      else
        # Add (None -> Down)
        console.log "none -> down, vote down by 1"
        vote('down')
        changeCounter('down')

      $('.vote').removeClass(activeClass)
      $(@).addClass(activeClass)
    return false






# up then down works in JS, but fails on refresh
# redis is receiving incr, then decr: 0 -> 1, then 1-> 0
# needs to be based on original value: 0 -> 1, then 0 -> -1
# when undoing vote (up-up), decrement by 1
# when switching vote (up-down), decrement by 2
