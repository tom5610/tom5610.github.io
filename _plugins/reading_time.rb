# Computes reading time using a content-type weighted model:
# - Prose: 200 WPM
# - Code blocks: 80 WPM
# - Images: 15 seconds each (average of simple screenshots and complex diagrams)
# Respects `reading_time` frontmatter override when present.

PROSE_WPM = 200
CODE_WPM = 80
SECONDS_PER_IMAGE = 15

Jekyll::Hooks.register :posts, :pre_render do |post|
  next if post.data['reading_time']

  content = post.content

  code_blocks = content.scan(/^```.*?^```/m)
  code_words = code_blocks.sum { |block| block.split.size }

  image_count = content.scan(/!\[\[[^\]]+\]\]/).size +
                content.scan(/!\[[^\]]*\]\([^)]+\)/).size

  total_words = content.split.size
  prose_words = [total_words - code_words, 0].max

  minutes = (prose_words / PROSE_WPM.to_f) +
            (code_words / CODE_WPM.to_f) +
            (image_count * SECONDS_PER_IMAGE / 60.0)

  post.data['reading_time'] = [minutes.ceil, 1].max
end
