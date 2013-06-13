# Generate a form to reply to a comment
reply_form = (parent_id) ->
  rid = $('.review').data('rid')
  """
  <form action="/reviews/#{rid}/comments/" data-remote="true" method="post" class="comment-reply-form">
    <input type="hidden" name="parent_id" value="#{parent_id}" />
    <textarea name="body"></textarea>
    <input class="btn btn-blue" type="submit" value="Submit" />
  </form>
  """


$ ->

  # Clicking reply button toggles reply form
  # If will be removed if already present,
  # else it will be generated and appended to the parent comment
  $(document.body).delegate '.reply-btn', 'click', ->
    $parent = $(@).parent().parent()
    $child  = $parent.find('.comment-reply-form')
    if $child.length
      $child.remove()
    else
      $parent.append reply_form($parent.data('id'))
    return false

  # Destroy child reply forms when focusing on main reply form
  $("#body").focus -> $('.comment-reply-form').remove()
