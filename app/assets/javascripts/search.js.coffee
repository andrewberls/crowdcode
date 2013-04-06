# Outline search form on focus
$search = $('.search-container')
$form   = $search.find('input')

setColor = (color) -> $search.css('border-color', color)

$form.on 'focus', -> setColor('#84B9E8')
$form.on 'blur',  -> setColor('#ddd')
