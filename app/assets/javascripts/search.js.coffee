# Outline search form and expand back and forth on focus

$search = $('.search-container')
$form   = $search.find('#q')
time    = 250

$form.on 'focus', ->
  $search.css('border-color', '#84B9E8')
  $search.animate width:'30em', time, ->
    $form.css('width', '24em')

$form.on 'blur',  ->
  $search.css('border-color', '#ddd')
  $form.css('width', '19em')
  $search.animate width:'25em', time
