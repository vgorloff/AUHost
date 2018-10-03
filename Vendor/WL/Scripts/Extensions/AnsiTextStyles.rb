
# See also https://stackoverflow.com/a/38735154/1418981

module AnsiTextStyles

  TEXT_ATTRIBUTES = {
      # text properties
      none: 0, # turn off all attributes
      bold: 1, bright: 1, # these do the same thing really
      italic: 3, underline: 4, blink: 5,
      reverse: 7, # swap foreground and background colours
      hide: 8, # foreground color same as background

      # foreground colours
      black: 30, grey: 90, lt_grey: 37, :white => 97,
      red: 31, lt_red: 91, 
      green: 32, lt_green: 92,
      dk_yellow: 33, brown: 33, yellow: 93,
      blue: 34, lt_blue: 94,
      magenta: 35, pink: 95, lt_magenta: 95,
      cyan: 36, lt_cyan: 96,
      default: 39,

      # background colours
      bg_black: 40, bg_grey: 100, bg_lt_grey: 47, bg_white: 107,
      bg_red: 41, bg_lt_red: 101,
      bg_green: 42, bg_lt_green: 102,
      bg_dk_yellow: 43, bg_brown: 43, bg_yellow: 103,
      bg_blue: 44, bg_lt_blue: 104,
      bg_magenta: 45, bg_pink: 105, bg_lt_magenta: 105,
      bg_cyan: 46, bg_lt_cyan: 106,
    }

  def self.text_attributes
    TEXT_ATTRIBUTES.keys
  end

  # applies the text attributes to the current string
  def style(*text_attributes)
    codes = TEXT_ATTRIBUTES.values_at(*text_attributes.flatten).compact
    "\e[%sm%s\e[m" % [codes.join(';'), self.to_s]
  end

  # instance method for each text attribute (chainable)
  TEXT_ATTRIBUTES.each {|attr, _| define_method(attr) { self.style(attr) } }

  # TODO: is there a way to just include AnsiTextAttributes???
  refine String do
    # applies the text attributes to the current string
    def style(*text_attributes)
      codes = TEXT_ATTRIBUTES.values_at(*text_attributes.flatten).compact
      "\e[%sm%s\e[m" % [codes.join(';'), self.to_s]
    end

    # instance method for each text attribute (chainable)
    TEXT_ATTRIBUTES.each {|attr, _| define_method(attr) { self.style(attr) } }
  end

end
