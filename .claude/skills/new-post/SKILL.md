---
name: new-post
description: Scaffold a new blog post with correct filename and valid frontmatter. Use when creating a new post. Pass the post title as arguments.
---

# New Post

Create a new blog post in `_posts/` with the correct filename and frontmatter.

## Instructions

1. Get the title from `$ARGUMENTS`. If no arguments provided, ask the user for a title.

2. Generate the filename using today's date and a slugified title:
   - Format: `YYYY-MM-DD-slugified-title.md`
   - Slug: lowercase, spaces to hyphens, strip non-alphanumeric characters (except hyphens)
   - Example: `2026-05-03-my-new-post.md`

3. Create the file at `_posts/<filename>` with this frontmatter:

```yaml
---
title: "<title>"
published: YYYY-MM-DD
author:
  - "[[Tom Liu]]"
description: ""
tags:
  - ""
---
```

4. The `published` date MUST match the filename date.

5. After creating the file, run `make lint-front` to verify the frontmatter passes validation.

6. Tell the user the file is ready and they can start writing content below the frontmatter.
