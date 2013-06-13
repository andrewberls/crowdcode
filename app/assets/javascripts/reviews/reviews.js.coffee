highlightCodeBlocks = ->
  $("code[class^='lang-']").addClass("prettyprint")


$ ->

  # Set markdown options
  marked.setOptions {
    gfm:         true
    tables:      true
    breaks:      false
    pedantic:    false
    sanitize:    true
    smartLists:  true
    smartypants: false
  }

  $review = $('.review')

  $body = $review.find('.review-body')
  $body.html marked( htmlDecode($body.html()) )

  highlightCodeBlocks()
