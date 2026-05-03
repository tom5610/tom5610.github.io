.PHONY: install build serve lint lint-config lint-front lint-md check-html test test-ui clean

install:
	bundle install

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve --livereload

lint: lint-config lint-front lint-md

lint-config:
	@ruby scripts/validate_config.rb

lint-front:
	@ruby scripts/validate_frontmatter.rb

lint-md:
	@bundle exec mdl --style .mdlstyle.rb _posts/

check-html: build
	@bundle exec htmlproofer _site \
		--no-enforce-https \
		--ignore-urls "/fonts.googleapis.com/,/fonts.gstatic.com/,/medium.com/" \
		--ignore-status-codes "403,999"

test: lint build check-html
	@echo "\n✓  All checks passed"

test-ui:
	@curl -s --max-time 2 http://localhost:4000 > /dev/null 2>&1 || \
		(echo "Starting Jekyll server..." && $(MAKE) serve > /dev/null 2>&1 &)
	@echo "Server ready at http://localhost:4000 — run /test-blog-ui in Claude Code"

clean:
	rm -rf _site .jekyll-cache
