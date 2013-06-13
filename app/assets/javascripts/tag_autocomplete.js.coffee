$form     = $('#new_review')
$tagInput = $("#tag_input")
$suggList = $('.suggestions-list')
keyUp     = 38
keyDown   = 40
keyEnter  = 13
keyEsc    = 27
keyBack   = 8
keyComma  = 188
selectedClass = 'selected'


# Bind keyup handlers when editor has focus
#   up/down - scroll through list of suggestions
#   enter - choose selected tag
#   backspace - erase most recent tag if present
#   letter - wait a bit and query the server for suggestions
bindSuggestionSelect = ->
  timeout = -1

  # Prevent enter key from prematurely submitting form
  $form.on 'keydown', (e) -> return false if e.which == keyEnter

  $tagInput.on 'keyup', (e) ->
    keyCode = (e.which || e.keyCode)

    if $suggList.is(':visible')
      switch keyCode
        when keyUp    then scrollSelection('up')
        when keyDown  then scrollSelection('down')
        when keyEnter then addTag $('.selected').text()
        else setFetchTimeout()
    else
      switch keyCode
        when keyBack then eraseLastTag()
        when keyComma
          addTag $(@).val().slice(0, -1)
          $(@).val('')
      setFetchTimeout() unless keyCode == keyEsc


# Remove key handlers (unfocused from editor)
unbindSuggestionSelect = ->
  $form.off('keydown')
  $tagInput.off('keyup')


# Don't overload server - wait a bit after keydown to fetch list
setFetchTimeout = ->
  clearTimeout(timeout) if timeout
  timeout = setTimeout(fetchSuggestions, 400)


# Move the currently selected suggestion up or down
scrollSelection = (dir) ->
  $suggs = $('.suggestion')
  endpoint = -> if dir == 'up' then $suggs.last() else $suggs.first()

  if $suggs.hasClass(selectedClass)
    $current = $('.selected').removeClass(selectedClass)
    $next    = if dir == 'up' then $current.prev() else $current.next()
    unless $next.length
      # Scrolled past the end - go to the first or last as appropriate
      $next = endpoint()
    $next.addClass(selectedClass)
  else
    # Nothing previously selected
    $sugg = endpoint()
    $sugg.addClass(selectedClass)


# Query the server for a list of suggestions matching current input
fetchSuggestions = () ->
  val = $.trim $tagInput.val()
  if val != ''
    $.get('/reviews/tags', { query: val })
    .done(populateSuggestions)
  else
    hideSuggestions()


# Empty the suggestions list and hide it
hideSuggestions = ->
  $suggList.hide()
  $suggList.empty()


# Build and display a list of suggestions for the user to choose
populateSuggestions = (listData) ->
  list = JSON.parse(listData)
  if list.length
    $suggList.empty()
    existing = $('.tag').map (i, el) -> $(el).text()

    # Don't suggest tags we've already selected
    for name in list
      if $.inArray(name, existing) == -1
        $suggList.append li('.suggestion', name)

    $suggList.show()


# Grow or shrink input field to fit next to tags
resizeInput = ->
  numTags = totalWidth = 0
  for el in $('.tag')
    numTags++
    totalWidth += $(el).outerWidth()

  tagMargin = 8
  newWidth  = $('.tag-editor').width() - totalWidth - (tagMargin * numTags)
  $tagInput.css('width', newWidth)


# Insert a new tag into the editor
addTag = (name) ->
  if name != ''
      $('.tags').append span('.tag', name)
    $tagInput.val('')
    hideSuggestions()
    resizeInput()


# Erases the last chosen tag (if present)
eraseLastTag = ->
  $last = $('.tag').last()
  if $last.length
    $last.remove()
    resizeInput()


# Populate a hidden field with the names of the tags we've chosen
normalizeTagList = ->
  tagNames = $('.tag').map( (i, el) -> $(el).text() ).get().join(',')
  $('#tag_list').val(tagNames)



$ ->
  $tagInput.on 'focus', bindSuggestionSelect
  $tagInput.on 'blur', unbindSuggestionSelect

  $(document.body).delegate '.suggestion', 'click', ->
    addTag $(@).text()

  $form.submit(normalizeTagList)

  # Hack to get hovers to work (CSS hovers weren't playing nice with arrow keys)
  $(document.body).delegate '.suggestion', 'mouseenter', ->
    $('.suggestion').removeClass(selectedClass)
    $(@).addClass(selectedClass)

  $(document.body).delegate '.suggestion', 'mouseleave', ->
    $(@).removeClass('selected')
