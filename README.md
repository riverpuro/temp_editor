# TempEditor

Edit temporary file with ENV['EDITOR'].

## Installation

Add this line to your application's Gemfile:

    gem 'temp_editor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install temp_editor

## Usage

1. Initialize TempEditor with Tempfile constructor arguments.
2. Register callback: before editing, after editing or both.
3. Make enduser edit tempfile.

    editor = TempEditor.new(['prefix', '.extension'])

    # Resister before editing callback:
    editor.before do |tempfile|
      tempfile.write("EDIT ME")
    end

    # Resister after editing callback:
    editor.after do |tempfile|
      puts tempfile.read
    end

    # launch editor
    editor.edit

See also: examples

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
