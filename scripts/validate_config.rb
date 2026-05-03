#!/usr/bin/env ruby
# Validates _config.yml structure and required fields.

require 'yaml'
require 'date'
require 'uri'

CONFIG_PATH = File.expand_path('../../_config.yml', __FILE__)

unless File.exist?(CONFIG_PATH)
  puts "✗  _config.yml not found at #{CONFIG_PATH}"
  exit 1
end

begin
  config = YAML.safe_load(File.read(CONFIG_PATH), permitted_classes: [Date, Time])
rescue Psych::SyntaxError => e
  puts "✗  _config.yml has invalid YAML: #{e.message}"
  exit 1
end

errors = []
warnings = []

REQUIRED_KEYS = %w[title url paginate permalink plugins].freeze
REQUIRED_KEYS.each do |key|
  errors << "missing required key '#{key}'" unless config.key?(key)
end

if config.key?('plugins') && !config['plugins'].is_a?(Array)
  errors << "'plugins' should be an array"
elsif config.key?('plugins') && !config['plugins'].include?('jekyll-paginate')
  errors << "'plugins' array is missing 'jekyll-paginate'"
end

if config.key?('url')
  begin
    uri = URI.parse(config['url'].to_s)
    errors << "'url' does not look like a valid URL" unless uri.scheme&.match?(/\Ahttps?\z/)
  rescue URI::InvalidURIError
    errors << "'url' is not a valid URI"
  end
end

if config.key?('description') && config['description'].to_s.strip.empty?
  warnings << "'description' is empty — consider adding one for SEO"
end

unless config.key?('baseurl')
  warnings << "'baseurl' is not set — fine for user pages, needed for project pages"
end

warnings.each { |w| puts "⚠  #{w}" }

if errors.empty?
  puts "✓  _config.yml passed validation"
  exit 0
else
  errors.each { |e| puts "✗  #{e}" }
  exit 1
end
