require 'rubygems'
require 'bundler/setup'

require 'byebug'
require 'awesome_print'
require 'nokogiri'

def txt_or_empty(obj)
  obj.nil? ? '' : obj.text
                     .gsub(/['"\\\x0]/, '\\\\\0')
                     .gsub(/^\n/, '')
                     .gsub(/\n/, '\n')
end

snippet = "'.php':\n"

Dir.glob('./ci-snippets/*.sublime-snippet') do |item|
  doc = File.open(item) { |f| Nokogiri::XML(f) }

  description = txt_or_empty doc.xpath('//snippet//description').first
  trigger = txt_or_empty doc.xpath('//snippet//tabTrigger').first
  content = txt_or_empty doc.xpath('//snippet//content').first

  snippet << "  '#{description}':\n"
  snippet << "    'prefix': '#{trigger}'\n"
  snippet << "    'body': '#{content}'\n"
end

File.open('atom-ci-snippets', 'w+') { |file| file.write snippet }
