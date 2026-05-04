# format.rb:
# mySociety library of formatting functions.
#
# Copyright (c) 2007 UK Citizens Online Democracy. All rights reserved.
# Email: francis@mysociety.org; WWW: http://www.mysociety.org/
#
# $Id: format.rb,v 1.12 2008/03/25 17:25:08 francis Exp $

module MySociety
  module Format
    # Word wrap the body of a text email.
    def self.wrap_email_body(body, line_width = 69, indent = '     ')
      body = body.gsub(/\r\n/, "\n") # forms post with \r\n by default
      paras = body.split(/\n\n/)

      result = ''
      for para in paras
        para.gsub!(/\s+/, ' ')
        para.gsub!(/(.{1,#{line_width}})(\s+|$)/, "#{indent}\\1\n")
        para.strip!
        result = result + indent + para + "\n\n"
      end
      result
    end

    # Returns text with obvious links made into HTML hrefs.
    # Taken originally from phplib/utility.php and from WordPress, tweaked somewhat.
    def self.make_clickable(text, params = {})
      nofollow = params[:nofollow]
      contract = params[:contract]

      ret = ' ' + text + ' '
      ret = ret.gsub(%r{(https?)://([^\s<>{}()]+[^\s.,<>{}()])}i,
                     "<a href='\\1://\\2'" + (nofollow ? " rel='nofollow'" : '') + '>\\1://\\2</a>')
      ret = ret.gsub(%r{(\s)www\.([a-z0-9-]+)((?:\.[a-z0-9\-~]+)+)((?:/[^ <>{}()\n\r]*[^., <>{}()\n\r])?)}i,
                     "\\1<a href='http://www.\\2\\3\\4'" + (nofollow ? " rel='nofollow'" : '') + '>www.\\2\\3\\4</a>')
      ret = ret.gsub(%r{(<a href='[^']*'(?: rel='nofollow')?>)([^<]{40})[^<]{3,}</a>}, '\\1\\2...</a>') if contract
      ret = ret.gsub(/(\s)([a-z0-9\-_.]+)@([^,< \n\r]*[^.,< \n\r])/i, '\\1<a href="mailto:\\2@\\3">\\2@\\3</a>')
      ret.strip
    end

    # Simplify bracketed URLs like: www.liverpool.gov.uk <http://www.liverpool.gov.uk>
    # (so that the URL appears only once, and so that the escaping of the < > doesn't
    # get &gt; contaminated into the linked URL)
    def self.simplify_angle_bracketed_urls(text)
      ret = ' ' + text + ' '
      # ret = ret.gsub(/(www\.[^\s<>{}()])\s+\<(https?):\/\//i, "\\1")
      ret = ret.gsub(%r{(www\.[^\s<>{}()]+)\s+<http://\1>}i, '\\1')
      ret.strip
    end

    # Differs from the Rails view helper pluralize, by not including the
    # number in the case of the singular.
    def self.fancy_pluralize(num, singular, plural)
      return singular if num == 1

      num.to_s + ' ' + plural
    end

    # Simplified a name to something usable in a URL
    def self.simplify_url_part(text, max_len = nil)
      text = text.downcase # this also clones the string, if we use downcase! we modify the original
      text.gsub!(/(\s|-|_)/, '_')
      text.gsub!(/[^a-z0-9_]/, '')
      text.gsub!(/_+/, '_')

      # If required, trim down to size
      unless max_len.nil?
        text = text[0..(max_len - 1)] if text.size > max_len
        # removing trailing _
        text.gsub!(/_*$/, '')
      end
      if text.size < 1
        text = 'user' # just do user1, user2 etc.
      end

      text
    end
  end
end
