module TagHelpers
  def content_tag(name, content, html_options={})
    %{<#{name}#{html_attributes(html_options)}>#{content}</#{name}>}
  end
  
  def tag(name, html_options={})
    %{<#{name}#{html_attributes(html_options)} />}
  end
  
  def image_tag(src, html_options = {})
    tag(:img, html_options.merge({:src=>src}))
  end
  
  def image(name, options = {})
    image_tag(append_image_extension("/images/#{name}"), options)
  end
  
  def javascript_tag(content = nil, html_options = {})
    content_tag(:script, javascript_cdata_section(content), html_options.merge(:type => "text/javascript"))
  end
  
  def link_to(name, href, html_options = {})
    html_options = html_options.stringify_keys
    confirm = html_options.delete("confirm")
    onclick = "if (!confirm('#{html_escape(confirm)}')) return false;" if confirm
    content_tag(:a, name, html_options.merge(:href => href, :onclick=>onclick))
  end
  
  def link_to_function(name, *args, &block)
    html_options = {}
    html_options = args.pop if args.last.is_a? Hash
    function = args[0] || ''
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'
    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end
  
  def mail_to(email_address, name = nil, html_options = {})
    html_options = html_options.stringify_keys
    encode = html_options.delete("encode").to_s
    cc, bcc, subject, body = html_options.delete("cc"), html_options.delete("bcc"), html_options.delete("subject"), html_options.delete("body")
    
    string = ''
    extras = ''
    extras << "cc=#{CGI.escape(cc).gsub("+", "%20")}&" unless cc.nil?
    extras << "bcc=#{CGI.escape(bcc).gsub("+", "%20")}&" unless bcc.nil?
    extras << "body=#{CGI.escape(body).gsub("+", "%20")}&" unless body.nil?
    extras << "subject=#{CGI.escape(subject).gsub("+", "%20")}&" unless subject.nil?
    extras = "?" << extras.gsub!(/&?$/,"") unless extras.empty?
    
    email_address = email_address.to_s
    
    email_address_obfuscated = email_address.dup
    email_address_obfuscated.gsub!(/@/, html_options.delete("replace_at")) if html_options.has_key?("replace_at")
    email_address_obfuscated.gsub!(/\./, html_options.delete("replace_dot")) if html_options.has_key?("replace_dot")
    
    if encode == "javascript"
      "document.write('#{content_tag("a", name || email_address_obfuscated, html_options.merge({ "href" => "mailto:"+email_address+extras }))}');".each_byte do |c|
        string << sprintf("%%%x", c)
      end
      "<script type=\"#{Mime::JS}\">eval(decodeURIComponent('#{string}'))</script>"
    elsif encode == "hex"
      email_address_encoded = ''
      email_address_obfuscated.each_byte do |c|
        email_address_encoded << sprintf("&#%d;", c)
      end
      
      protocol = 'mailto:'
      protocol.each_byte { |c| string << sprintf("&#%d;", c) }
      
      email_address.each_byte do |c|
        char = c.chr
        string << (char =~ /\w/ ? sprintf("%%%x", c) : char)
      end
      content_tag "a", name || email_address_encoded, html_options.merge({ "href" => "#{string}#{extras}" })
    else
      content_tag "a", name || email_address_obfuscated, html_options.merge({ "href" => "mailto:#{email_address}#{extras}" })
    end
  end
  
  private
    
    def cdata_section(content)
      "<![CDATA[#{content}]]>"
    end
    
    def javascript_cdata_section(content) #:nodoc:
      "\n//#{cdata_section("\n#{content}\n//")}\n"
    end
    
    def html_attributes(options)
      unless options.blank?
        attrs = []
        options.each_pair do |key, value|
          if value == true
            attrs << %(#{key}="#{key}") if value
          else
            attrs << %(#{key}="#{value}") unless value.nil?
          end
        end
        " #{attrs.sort * ' '}" unless attrs.empty?
      end
    end
    
    def append_image_extension(name)
      unless name =~ /\.(.*?)$/
        name + '.png'
      else
        name
      end
    end
module RenderHelpers
    def render(partial, options={})
      if partial.is_a?(Hash)
        options = options.merge(partial)
        partial = options.delete(:partial)
      end  
      template = options.delete(:template)
      case
      when partial
        render_partial(partial)
      when template
        render_template(template)
      else
        raise "render options not supported #{options.inspect}"
      end
    end
    
    def render_partial(partial)
      render_template(partial, :partial => true)
    end
    
    def render_template(template, options={})
      path = File.dirname(parser.script_filename)
      if template =~ %r{^/}
        template = template[1..-1]
        path = @root_path
      end
      filename = template_filename(File.join(path, template), :partial => options.delete(:partial))
      if File.file?(filename)
        parser.parse_file(filename)
      else
        raise "File does not exist #{filename.inspect}"
      end
    end
    
    private
      
      def template_filename(name, options)
        path = File.dirname(name)
        template = File.basename(name)
        template = "_" + template if options.delete(:partial)
        template += extname(parser.script_filename) unless name =~ /\.[a-z]{3,4}$/
        File.join(path, template)
      end
      
      def extname(filename)
        /(\.[a-z]{3,4}\.[a-z]{3,4})$/.match(filename)
        $1 || File.extname(filename) || ''
      end
  end

module JahJekyllHelpers
include TagHelpers
include RenderHelpers
puts "I'm LOADED!"
  #helpers for haml layouts
    def nav_item( name, href, current_path = '/', *args )
      html_options = {}
      html_options = args.last.pop if args.last.is_a? Hash
      active = ( href.downcase == current_path.downcase ) ? {:class => 'active'} : {}
      link_to( name, href, html_options )
    end
end
end
