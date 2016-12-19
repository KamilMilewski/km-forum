# :nodoc:
module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'KMForum'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  # Thanks to this method override we don't need nokogiri gem. Code blocks are
  # colored directly in redcarpet.
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end

  def markdown(content)
    # render = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    # renderer object
    render = HTMLwithPygments.new(
      # Insert <br> tag in place of spaces in doc.
      hard_wrap: true,
      # Do not allow any user-inputted HTML in out.
      filter_html: true
    )
    options = {
      # Links highlighting
      autolink: true,
      # Do not parse emphasis inside of words (some_thing).
      no_intra_emphasis: true,
      # Do not parse lines beginning with four lines to code blocks.
      disable_indented_code_blocks: true,
      # Allow to use ~~~ruby code ~~~ blocks.
      fenced_code_blocks: true,
      # HTML blocks do not need to be surrounded by empty line.
      lax_spacing: true,
      # ~~strikethrough~~ will make strikethrough text.
      strikethrough: true,
      # 3^(2) will print 3 with 2 as a top index.
      superscript: true
    }
    Redcarpet::Markdown.new(render, options).render(content).html_safe
  end
end
