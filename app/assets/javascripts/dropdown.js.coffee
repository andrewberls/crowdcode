$doc = $(document)

$('.dropdown-toggle').click (e) ->
  $container = $(@).next('.dropdown-container')
  $('.dropdown-container').not($container).hide() # Hide any open dropdowns
  $container.toggle()

  $doc.on 'click', ->
    $container.hide()
    $doc.unbind('click')

  e.stopPropagation()
  return false
