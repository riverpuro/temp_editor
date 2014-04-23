#!/usr/bin/env ruby
require 'temp_editor'

# requirements:
# - Dayone: http://dayoneapp.com/
# - Dayone-cli: http://dayoneapp.com/cli
class Dayone
  COMMAND = "dayone"

  def initialize(options = [])
    editor(options).edit
  end

  private
  def editor(options)
    TempEditor.new(["dayone", ".markdown"]) do |file|
      cmd = command(options)
      File.popen(cmd, 'w'){|io| io.write(file.read) }
    end
  end

  def command(options)
    [COMMAND, options, 'new'].flatten.join(' ')
  end
end

if __FILE__ == $0
  Dayone.new ARGV
end
