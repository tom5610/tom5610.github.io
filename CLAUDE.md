# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Jekyll 4.x blog hosted on GitHub Pages. Posts are written in Obsidian-flavored markdown and transformed to standard Kramdown at build time by `_plugins/obsidian_compat.rb`.

## Commands

- `make lint` — fast validation (config + frontmatter + markdown), no build needed
- `make test` — full pipeline: lint + build + htmlproofer
- `make serve` — local dev server at localhost:4000 with livereload
- `make clean` — remove _site and .jekyll-cache

## Post Frontmatter Schema

Posts live in `_posts/` with filename `YYYY-MM-DD-slug.md`. The filename date must match the `published` field.

Required fields:
- `title` — non-empty string
- `published` — date matching filename (the plugin converts this to Jekyll's `date` at build time)

Optional fields:
- `tags` — array of strings
- `author` — string or array; Obsidian `[[brackets]]` are stripped by the plugin
- `description` — string
- `source` — URL string

The `created` field is automatically removed by the plugin. Do not use `date` directly — use `published`.

## Obsidian Compatibility

The `obsidian_compat.rb` plugin transforms these patterns at build time:
- `[[Page]]` and `[[Page|Alias]]` — wiki-links to markdown links
- `![[image.png]]` — image embeds to `![](/assets/image.png)`
- `%%comment%%` — hidden comments stripped
- `> [!note]` — callouts to bold blockquotes
- `[text|more](url)` — pipe in link text to dash

Write posts using Obsidian syntax; the plugin handles conversion. Run `make lint` to validate before pushing.

## Markdown Linting

`.mdlstyle.rb` excludes rules that conflict with Obsidian/Jekyll: MD002 (first heading level), MD009 (trailing spaces in blockquote continuations), MD013 (line length), MD032 (lists in frontmatter), MD033 (inline HTML), MD034 (bare URLs), MD041 (first line heading). Do not re-enable these without testing against existing posts.

## Deployment

Push to `main` triggers GitHub Actions: Ruby 3.3 + `bundle exec jekyll build` + deploy to GitHub Pages. No feature branches or PRs — direct to main.

## Style

- 2-space indentation, LF line endings, UTF-8 (see `.editorconfig`)
- Permalink format: `pretty` (URLs like `/2026/04/06/post-slug/`)
- 5 posts per page (pagination)
