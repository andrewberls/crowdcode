module ReviewsHelper

  CODE_START = '<pre>'
  CODE_END   = '</pre>'

  def teaser(review, length=100)
    teaser = review.body[0..length]

    if start_idx = teaser.index(CODE_START)
      if end_idx = teaser.index(CODE_END)
        # Code block - slice it out and compact whitespace
        end_idx += CODE_END.length # Need to go to the end of the tag
        block   = teaser[start_idx..end_idx]
        teaser.gsub!(block, '')
      else
        # Dangling start - erase everything after
        teaser.slice!(start_idx..teaser.length)
      end
    end

    strip_tags(teaser).squish
  end

end
