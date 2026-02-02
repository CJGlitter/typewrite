# frozen_string_literal: true

require_relative "typewrite/version"
require "io/console"

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
  # @param interrupt [Boolean, Symbol, Array] enable interrupt mode (default: false)
  #   - false: no interrupt (default)
  #   - true or :enter: interrupt on Enter key
  #   - :any: interrupt on any key
  #   - Array: interrupt on specific keys (e.g., ["q", "x", " "])
  # @return [void]
  def self.write(input, type_rate = 0.1, punc_rate = 1.5, line_break = true, interrupt: false)
    return write_simple(input, type_rate, punc_rate, line_break) unless interrupt

    write_interruptible(input, type_rate, punc_rate, line_break, interrupt)
  end

  # Simple non-interruptible write (original behavior)
  #
  # @param input [String] the message to display
  # @param type_rate [Float] seconds between each character
  # @param punc_rate [Float] extra pause after punctuation
  # @param line_break [Boolean] add newline at end
  # @return [void]
  private_class_method def self.write_simple(input, type_rate, punc_rate, line_break)
    input.each_char do |char|
      print char
      sleep(punc_rate) if PUNCTUATION.include?(char)
      sleep(type_rate)
    end
    print "\n" if line_break
  end

  # Interruptible write with keyboard input detection
  #
  # @param input [String] the message to display
  # @param type_rate [Float] seconds between each character
  # @param punc_rate [Float] extra pause after punctuation
  # @param line_break [Boolean] add newline at end
  # @param interrupt_config [Boolean, Symbol, Array] interrupt configuration
  # @return [void]
  private_class_method def self.write_interruptible(input, type_rate, punc_rate, line_break, interrupt_config)
    chars = input.chars
    index = 0

    $stdin.raw do |io|
      while index < chars.length
        # Check for keypress (non-blocking)
        if io.wait_readable(0)
          pressed = io.getc
          if key_matches?(pressed, interrupt_config)
            # Print remaining text immediately
            print chars[index..].join
            break
          end
        end

        print chars[index]
        sleep(punc_rate) if PUNCTUATION.include?(chars[index])
        sleep(type_rate)
        index += 1
      end
    end

    print "\n" if line_break
  end

  # Checks if a pressed key matches the interrupt configuration
  #
  # @param char [String] the pressed character
  # @param config [Boolean, Symbol, Array] interrupt configuration
  # @return [Boolean] true if the key should trigger an interrupt
  private_class_method def self.key_matches?(char, config)
    case config
    when true, :enter then ["\r", "\n"].include?(char)
    when :any then true
    when Array then config.include?(char)
    else false
    end
  end
end
