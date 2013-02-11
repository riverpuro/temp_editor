# -*- encoding: utf-8 -*-

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'temp_editor'

class RemoteResource
  def initialize(resource_id)
    @path = "http://example.com/diary/#{resource_id}"
  end

  def get
    "# contents for #{@path}\n"
  end

  def put(content)
    puts "update #{@path}"
    puts "=" * 80
    puts content
  end
end

class RemoteEditor
  def initialize(remote_resource_id)
    @remote_resource = RemoteResource.new(remote_resource_id)

    @editor = TempEditor.new(['remote', '.markdown'])

    @editor.before do |file|
      content = @remote_resource.get
      file.write(content)
    end

    @editor.after do |file|
      @remote_resource.put(file.read)
    end
  end

  def edit
    @editor.edit
  end
end

if __FILE__ == $0
  remote_editor = RemoteEditor.new(1)
  remote_editor.edit
end
