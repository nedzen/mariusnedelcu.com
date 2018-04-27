require 'middleman-core/renderers/redcarpet'
require 'middleman-syntax/extension'
require 'redcarpet'
require 'slim'

class String
  def identify
    self.downcase.gsub(/[^\w]/, '-')
  end
end

module Middleman
  module Renderers
    class CustomTemplate < RedcarpetTemplate
      def allows_script
        true
      end
    end
    module CustomRenderer
      include ::Redcarpet::Render::SmartyPants
      def table(header, body)
        res = '<table class="table table-bordered">'
        res += "<thead>#{header}</thead>" if header.present?
        res += "<tbody>#{body}</body>"
        res + '</table>'
      end
      def block_code(code, language)
        code.gsub!(%r{[\n\r\s]*$}, '')
        Middleman::Syntax::Highlighter.highlight(code, language)
      end
      def list_item(content, list_type)
        node_name = { ordered: 'ol', unordered: 'li' }[list_type]
        content.sub!(/^\s*\[\s+\]/, '<input type="checkbox" disabled>')
        content.sub!(/^\s*\[\s*x\s*\]/, '<input type="checkbox" checked disabled>')
        "<#{node_name}>#{content}</#{node_name}>"
      end
    end
  end
end

::Middleman::Renderers::MiddlemanRedcarpetHTML.send :include, ::Middleman::Renderers::CustomRenderer

# for when I will know ruby well enough to be able 
# to play with preprocessors.
# as seen here http://opticalcortex.com/markdown-blockquote-attribution-with-redcarpet/
# class StoryMarkdown::Render < Redcarpet::Render::HTML
#   def cite(text)
#     # allow attributes, starting with a --
#     text.gsub! /(-- )(.*)\r/ do
#       "<cite>#{$2}</cite>"
#     end
#     text
#   end
#   alias_method :preprocess, :cite

#   def cite_html_clean(text)
#     # we want attributions to be block level and not live inside paragraphs
#     text.gsub! /(<cite>.*<\/cite>)(<\/p>)/ do
#       "#{$2}#{$1}"
#     end
#     text
#   end
#   alias_method :postprocess, :cite_html_clean
# end
