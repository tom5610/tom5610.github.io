all
exclude_rule 'MD002' # first header level — blog posts use H2 since H1 comes from frontmatter
exclude_rule 'MD009' # trailing spaces — Obsidian generates `> ` for blank blockquote lines
exclude_rule 'MD013' # line length — prose doesn't need wrapping
exclude_rule 'MD032' # blank lines around lists — false positive on frontmatter YAML arrays
exclude_rule 'MD033' # inline HTML — Jekyll uses HTML in markdown
exclude_rule 'MD034' # bare URLs — acceptable in blog posts
exclude_rule 'MD041' # first line heading — frontmatter comes first
