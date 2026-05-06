# Transforms Obsidian-flavored markdown into standard Kramdown-compatible
# markdown at build time, so source files can stay in Obsidian format.

module ObsidianCompat
  # [[Page|Alias]] → [Alias](page) — must run before the plain [[Page]] rule
  WIKILINK_ALIASED = /\[\[([^\]|]+)\|([^\]]+)\]\]/

  # [[Page Name]] → [Page Name](page-name)
  WIKILINK_PLAIN = /\[\[([^\]]+)\]\]/

  # ![[image.png]] → ![](image.png)
  EMBED_IMAGE = /!\[\[([^\]]+\.(png|jpg|jpeg|gif|svg|webp))\]\]/i

  # %%hidden comment%% → removed
  COMMENT = /%%.*?%%/m

  # > [!note] or > [!warning] etc. → **Note:** blockquote
  CALLOUT = /^(>\s*)\[!(\w+)\]\s*(.*)$/

  # Pipe in markdown link text: [text | more](url) → [text - more](url)
  # Negative lookbehind avoids matching table rows
  PIPE_IN_LINK = /\[([^\]]*)\|([^\]]*)\]\(([^)]+)\)/

  def self.slugify(title)
    title.strip.downcase.gsub(/\s+/, '-').gsub(/[^\w-]/, '')
  end

  def self.transform(content, assets_dir: nil)
    output = content.dup

    base = assets_dir ? "/assets/#{assets_dir}" : "/assets"
    output.gsub!(EMBED_IMAGE) { |_| "![](#{base}/#{$1})" }
    output.gsub!(COMMENT, '')
    output.gsub!(CALLOUT) { |_| "#{$1}**#{$2.capitalize}:** #{$3}" }
    output.gsub!(PIPE_IN_LINK) { |_| "[#{$1.strip} - #{$2.strip}](#{$3})" }
    output.gsub!(WIKILINK_ALIASED) { |_| "[#{$2}](#{slugify($1)})" }
    output.gsub!(WIKILINK_PLAIN) do |_|
      target = $1
      if target.start_with?('#')
        heading = target[1..]
        "[#{target}](##{slugify(heading)})"
      else
        "[#{target}](#{slugify(target)})"
      end
    end

    output
  end

  def self.fix_frontmatter(data)
    if data['published'].is_a?(String) || data['published'].is_a?(Date)
      data['date'] ||= data['published']
      data.delete('published')
    end

    data.delete('created')

    if data['author'].is_a?(Array)
      data['author'] = data['author']
        .map { |a| a.gsub(/\[\[|\]\]/, '') }
        .first
    elsif data['author'].is_a?(String)
      data['author'] = data['author'].gsub(/\[\[|\]\]/, '')
    end
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  ObsidianCompat.fix_frontmatter(post.data)
  assets_dir = post.data['assets_dir']
  post.content = ObsidianCompat.transform(post.content, assets_dir: assets_dir)
  payload['post']['content'] = post.content if payload && payload['post']
  post.excerpt.content = ObsidianCompat.transform(post.excerpt.content, assets_dir: assets_dir)
end
