#!/usr/bin/env ruby
# Validates frontmatter in _posts/*.md files against the expected schema.
# Checks raw (pre-plugin) frontmatter — the obsidian_compat plugin transforms
# `published` → `date` at build time, so we validate what the author writes.

require 'yaml'
require 'date'

POSTS_DIR = File.expand_path('../../_posts', __FILE__)
FILENAME_PATTERN = /\A(\d{4})-(\d{2})-(\d{2})-.+\.md\z/

errors = []
post_count = 0

Dir.glob(File.join(POSTS_DIR, '*.md')).sort.each do |path|
  filename = File.basename(path)
  post_count += 1
  post_errors = []

  unless filename.match?(FILENAME_PATTERN)
    post_errors << "filename does not match YYYY-MM-DD-slug.md pattern"
  end

  raw = File.read(path)
  unless raw.start_with?("---")
    post_errors << "missing YAML frontmatter"
    errors << [filename, post_errors]
    next
  end

  parts = raw.split("---", 3)
  begin
    fm = YAML.safe_load(parts[1], permitted_classes: [Date, Time])
  rescue Psych::SyntaxError => e
    post_errors << "invalid YAML: #{e.message}"
    errors << [filename, post_errors]
    next
  end

  fm ||= {}

  if fm['title'].nil? || fm['title'].to_s.strip.empty?
    post_errors << "missing or empty 'title'"
  end

  pub = fm['published'] || fm['date']
  if pub.nil?
    post_errors << "missing 'published' (or 'date') field"
  else
    begin
      pub_date = pub.is_a?(Date) ? pub : Date.parse(pub.to_s)
      m = filename.match(FILENAME_PATTERN)
      if m
        file_date = Date.new(m[1].to_i, m[2].to_i, m[3].to_i)
        if pub_date != file_date
          post_errors << "filename date #{file_date} does not match published date #{pub_date}"
        end
      end
    rescue ArgumentError
      post_errors << "'published' is not a valid date: #{pub.inspect}"
    end
  end

  if fm.key?('tags') && !fm['tags'].is_a?(Array)
    post_errors << "'tags' should be an array, got #{fm['tags'].class}"
  end

  if fm.key?('author') && !fm['author'].is_a?(String) && !fm['author'].is_a?(Array)
    post_errors << "'author' should be a string or array, got #{fm['author'].class}"
  end

  errors << [filename, post_errors] unless post_errors.empty?
end

if post_count == 0
  puts "⚠  No posts found in #{POSTS_DIR}"
  exit 0
end

if errors.empty?
  puts "✓  All #{post_count} post(s) passed frontmatter validation"
  exit 0
else
  errors.each do |filename, errs|
    errs.each { |e| puts "✗  #{filename}: #{e}" }
  end
  puts "\n#{errors.size} post(s) with errors out of #{post_count}"
  exit 1
end
