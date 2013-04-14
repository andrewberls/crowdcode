$ ->
  # ----------------------
  #  Votes
  # ----------------------

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



  # ----------------------
  #  Comments
  # ----------------------

  # Generate a form to reply to a comment
  reply_form = (parent_id) ->
    """
    <form action="/reviews/#{rid()}/comments/" data-remote="true" method="post" class="comment-reply-form">
      <input type="hidden" name="parent_id" value="#{parent_id}" />
      <textarea name="body"></textarea>
      <input class="btn btn-blue" type="submit" value="Submit" />
    </form>
    """

  # CLicking reply button toggles reply form
  # If will be removed if already present,
  # else it will be generated and appended to the parent comment
  $(document.body).delegate '.reply-btn', 'click', ->
    $parent = $(@).parent().parent()
    $childForm = $parent.find('.comment-reply-form')
    if $childForm.length
      $childForm.remove()
    else
      $parent.append reply_form($parent.data('id'))
    return false

  # Destroy child reply forms when focusing on main reply form
  $("#body").focus -> $('.comment-reply-form').remove()
