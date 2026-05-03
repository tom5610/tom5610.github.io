# tom5610.github.io

Personal blog by [Tom Liu](https://tom5610.github.io) — *Learning from Public*.

Built with [Jekyll](https://jekyllrb.com/) and the [Lanyon](https://github.com/poole/lanyon) theme. Posts are authored in [Obsidian](https://obsidian.md/) and transformed to standard markdown at build time.

## Prerequisites

- Ruby 3.3+ (managed via [rbenv](https://github.com/rbenv/rbenv))
- Bundler (`gem install bundler`)

## Setup

```bash
rbenv install 3.3.11    # if not already installed
bundle install
```

## Development

```bash
make serve              # local server at http://localhost:4000 with livereload
make lint               # fast validation — config, frontmatter, markdown (<1s)
make test               # full pipeline — lint + build + HTML link checking
make clean              # remove generated files
```

## Writing a Post

Create a new file in `_posts/` with the naming convention `YYYY-MM-DD-slug.md`:

```yaml
---
title: "Post Title"
published: 2026-05-03
author:
  - "[[Tom Liu]]"
description: "Brief description"
tags:
  - "topic"
---

Your content here. Obsidian syntax like [[wiki-links]], ![[image.png]],
%%comments%%, and > [!note] callouts are supported.
```

The `published` date must match the filename date. Run `make lint` to validate before pushing.

## Obsidian Compatibility

The custom plugin at `_plugins/obsidian_compat.rb` transforms Obsidian-flavored markdown to standard Kramdown at build time:

| Obsidian Syntax | Transforms To |
|---|---|
| `[[Page]]` | `[Page](page)` |
| `[[Page\|Alias]]` | `[Alias](page)` |
| `![[image.png]]` | `![](/assets/image.png)` |
| `%%comment%%` | *(removed)* |
| `> [!note] text` | `> **Note:** text` |

## Deployment

Push to `main` triggers automatic deployment via GitHub Actions to [GitHub Pages](https://tom5610.github.io).

## Project Structure

```
_posts/          Blog posts (Obsidian-flavored markdown)
_layouts/        Page templates (default, post, page)
_includes/       Shared components (head, sidebar)
_plugins/        Custom Jekyll plugins (Obsidian compatibility)
public/          Static assets (CSS, JS, images)
scripts/         Build validation scripts
```

## License

Theme based on [Lanyon](https://github.com/poole/lanyon) by Mark Otto, released under the [MIT License](LICENSE.md).
