# Get the rid of the current review
rid = -> $('.review').data('rid')

# POST a vote (direction and amount)
vote = (dir) ->
  $.post "/reviews/#{rid()}/votes", { dir: dir }

# Change the display of the vote counter (direction and amount)
changeCounter = (dir, amt=1) ->
  $votes = $('.votes-container').find('.votes')
  count  = parseInt($votes.html())
  newAmt = if dir == 'up' then count+amt else count-amt
  $votes.html(newAmt)


$ ->
  activeClass = 'vote-active'

  $('.vote-up, .vote-down').click ->
    dir = $(@).attr('id')
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



# Generate a form to reply to a comment
reply_form = (parent_id) ->
  """
  <form action="/reviews/comments/" data-remote="true" method="post" class="comment-reply-form">
    <input type="hidden" name="parent_id" value="#{parent_id}" />
    <textarea name="body"></textarea>
    <input class="btn btn-blue" type="submit" value="Submit" />
  </form>
  """


$('.reply-button').click ->
  $link = $(this)
  parent_id = $link.parent().parent().data('id')
  form = reply_form(parent_id)
  $(".comments-container").append(form)
  return false
