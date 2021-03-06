activeClass = 'vote-active'

# POST a vote (direction and amount)
vote = (dir) ->
  rid = $('.review').data('rid')
  $.post "/reviews/#{rid}/votes", { dir: dir }


# Change the display of the vote counter (direction and amount)
changeCounter = (dir, amt=1) ->
  $votes = $('.votes-container').find('.votes')
  count  = parseInt($votes.html())
  newAmt = if dir == 'up' then count+amt else count-amt
  $votes.html(newAmt)



$ ->

  $('.vote-up, .vote-down').click ->
    dir      = $(@).attr('id')
    $other   = if dir == 'up' then $('.vote-down') else $('.vote-up')
    opposite = $other.attr('id')

    if $(@).hasClass(activeClass)
      # Previous vote is same - UNDO
      vote(dir)
      changeCounter(opposite)
      $(@).removeClass(activeClass)
    else
      if $other.hasClass(activeClass)
        # Switch - vote DIR by 2
        vote(dir)
        changeCounter(dir, 2)
      else
        # No previous vote - vote DIR by 1
        vote(dir)
        changeCounter(dir)

      $('.vote-up, .vote-down').removeClass(activeClass)
      $(@).addClass(activeClass)
    return false
