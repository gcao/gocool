module Gocool  
  class Email
    # http://tfletcher.com/lib/rfc822.rb
    #
    # RFC822 Email Address Regex
    # --------------------------
    # 
    # Originally written by Cal Henderson
    # c.f. http://iamcal.com/publish/articles/php/parsing_email/
    #
    # Translated to Ruby by Tim Fletcher, with changes suggested by Dan Kubb.
    #
    # Licensed under a Creative Commons Attribution-ShareAlike 2.5 License
    # http://creativecommons.org/licenses/by-sa/2.5/
    # 
    if RUBY_VERSION.to_f < 1.9
      FORMAT = begin
        qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
        dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
        atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
        quoted_pair = '\\x5c[\\x00-\\x7f]'
        domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
        quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
        domain_ref = atom
        sub_domain = "(?:#{domain_ref}|#{domain_literal})"
        word = "(?:#{atom}|#{quoted_string})"
        domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
        local_part = "#{word}(?:\\x2e#{word})*"
        addr_spec = "#{local_part}\\x40#{domain}"
      
        /\A#{addr_spec}\z/
      end
    else
      FORMAT = begin
        qtext = '[^\\u000d\\u0022\\u005c\\u0080-\\u00ff]'
        dtext = '[^\\u000d\\u005b-\\u005d\\u0080-\\u00ff]'
        atom = '[^\\u0000-\\u0020\\u0022\\u0028\\u0029\\u002c\\u002e\\u003a-\\u003c\\u003e\\u0040\\u005b-\\u005d\\u007f-\\u00ff]+'
        quoted_pair = '\\u005c[\\u0000-\\u007f]'
        domain_literal = "\\u005b(?:#{dtext}|#{quoted_pair})*\\u005d"
        quoted_string = "\\u0022(?:#{qtext}|#{quoted_pair})*\\u0022"
        domain_ref = atom
        sub_domain = "(?:#{domain_ref}|#{domain_literal})"
        word = "(?:#{atom}|#{quoted_string})"
        domain = "#{sub_domain}(?:\\u002e#{sub_domain})*"
        local_part = "#{word}(?:\\u002e#{word})*"
        addr_spec = "#{local_part}\\u0040#{domain}"

        /\A#{addr_spec}\z/
      end
    end
      
    def self.valid? email
      email =~ FORMAT
    end
  end
end