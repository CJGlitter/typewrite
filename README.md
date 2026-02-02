## Typewrite ##

[![Gem Version](https://badge.fury.io/rb/typewrite.svg)](https://badge.fury.io/rb/typewrite)

Typewrite is a Ruby library that prints console messages "typewriter" style, or letter-by-letter.

### Installation ###
    #Installing as Ruby gem
    $gem install typewrite

    #Cloning the repsository
    $git clone git@github.com:CJGlitter/typewrite.git
### Usage ###

```ruby
require "typewrite"
Typewrite.write("Your message here!")
```

### Options ###
The variable options include type rate, pause length, and whether or not a newline is desired at the end of each message. By default, the type rate is one character per 0.1 second with a 1.5 second pause after each punctuation character `['.','?','!']` with a new line after each message. 

You can adjust the type rate and pause length with integers and turn off the newlines by passing integers and a boolean respectively. 

Example

```ruby
message = "Here's your message"
Typewrite.write(message, 0.05, 0, false)
```
That would result in a message that types a character every 0.05 seconds with no punctuation pauses and no newlines after each message.

## Development

### Running Tests

```bash
bundle install
bundle exec rake        # Run tests + linting
bundle exec rspec       # Run tests only
bundle exec rubocop     # Run linting only
```

### Code Quality

This project uses RuboCop for linting. Please ensure your code passes linting before submitting a PR:

```bash
bundle exec rubocop -A  # Auto-fix issues
```

## Versioning

Typewrite follows the [Semantic Versioning](http://semver.org/) standard.

### Contributing ###

Bug reports and pull requests are welcome on GitHub at https://github.com/CJGlitter/typewrite

### License ###
Copywrite ©Cory Davis 2023

https://cjglitter.com

Released under the MIT license. See LICENSE file for details.
