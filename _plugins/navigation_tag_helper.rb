module Jekyll
  class RenderNavigationTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
     pages = context.registers[:site].tags
     "#{pages}"
    end
  end
end

Liquid::Template.register_tag('render_navigation', Jekyll::RenderNavigationTag)

