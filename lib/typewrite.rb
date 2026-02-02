# frozen_string_literal: true

require_relative "typewrite/version"

# Prints console messages with a typewriter effect (letter-by-letter).
#
# @example Basic usage
#   Typewrite.write("Hello, World!")
#
# @example Custom timing
#   Typewrite.write("Fast typing", 0.05, 0.5, false)
#
module Typewrite
  # Characters that trigger an extra pause
  PUNCTUATION = [".", "?", "!"].freeze

  # Prints a message with typewriter effect.
  #
  # @param input [String] the message to display
  # @param type_rate [Float] seconds between each character (default: 0.1)
  # @param punc_rate [Float] extra pause after punctuation (default: 1.5)
  # @param line_break [Boolean] add newline at end (default: true)
  # @return [void]
  def self.write(input, type_rate = 0.1, punc_rate = 1.5, line_break = true)
    input.each_char do |char|
      print char
      sleep(punc_rate) if PUNCTUATION.include?(char)
      sleep(type_rate)
    end
    print "\n" if line_break
  end
end
