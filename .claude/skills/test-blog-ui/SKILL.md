---
name: test-blog-ui
description: Run UI tests on the Jekyll blog using Playwright MCP tools. Verifies home page post listing and individual post page rendering after creating or editing a blog post.
---

# Blog UI Testing Skill

Run visual and structural UI tests on the local Jekyll blog at `http://localhost:4000` using the Playwright MCP browser tools. Save all screenshots to the `.playwright-mcp/` directory. Follow these steps in order.

## Step 0: Ensure Server Is Running

Check if the Jekyll server is up:

```bash
curl -s --max-time 2 http://localhost:4000 > /dev/null 2>&1
```

If it fails, start the server and wait for it:

```bash
cd /Users/tomliu/workspace/testing/tom5610.github.io && eval "$(rbenv init - zsh)" && bundle exec jekyll serve --livereload &
```

Then poll `curl -s --max-time 1 http://localhost:4000` every 2 seconds, up to 30 seconds, until it returns successfully. If it never comes up, report the failure and stop.

## Step 1: Home Page Tests

1. Use `browser_navigate` to go to `http://localhost:4000/`.
2. Use `browser_snapshot` to get the accessibility tree.
3. Verify in the snapshot:
   - The masthead area contains the text "Tom Liu" and "Learning from Public"
   - There is at least one post listing with a title (link text inside a heading), a date string, and excerpt text
   - A pagination area exists (text like "Older" or "Newer")
4. Use `browser_console_messages` and check for any errors (level "error"). Warnings are acceptable.
5. Use `browser_take_screenshot` with filename `.playwright-mcp/home-page.png`.

Record pass/fail for each check.

## Step 2: Post Page Tests

Determine the post to test:
- If the conversation has a `POST_URL` from a hook, use that URL.
- Otherwise, click the first post title link on the home page to navigate to it.

Once on the post page:

1. Use `browser_snapshot` to get the accessibility tree.
2. Verify in the snapshot:
   - The post title appears in a heading
   - A date and "min read" text are present
   - The post body contains content (at least one subheading or paragraph of text)
   - If there are related posts, a "Related posts" section with links exists
3. Use `browser_console_messages` and check for errors.
4. Use `browser_take_screenshot` with filename `.playwright-mcp/post-page.png`.

Record pass/fail for each check.

## Step 3: Report Results

Output a structured report like this:

```
## UI Test Results

### Home Page (http://localhost:4000/)
- [PASS/FAIL] Masthead renders with site title and tagline
- [PASS/FAIL] Post listing shows at least one post with title, date, excerpt
- [PASS/FAIL] Pagination section present
- [PASS/FAIL] No JavaScript console errors

### Post Page (<url>)
- [PASS/FAIL] Post title renders in heading
- [PASS/FAIL] Date and read time displayed
- [PASS/FAIL] Post content renders with formatted text
- [PASS/FAIL] Related posts section (if applicable)
- [PASS/FAIL] No JavaScript console errors

Screenshots saved to .playwright-mcp/.
```

## Step 4: Cleanup

Use `browser_close` to close the browser. Do NOT stop the Jekyll server (it stays running for livereload during editing).
