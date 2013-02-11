# -*- encoding: utf-8 -*-
require 'tempfile'

class TempEditor
  VERSION = '0.0.1'

  class EditorConfigureError < StandardError; end

  attr_reader :tempfile

  def initialize(basename, *rest)
    @tempfile = Tempfile.new(basename, *rest)
  end

  def before(&block)
    @before_callback = build_callback(&block)
  end

  def after(&block)
    @after_callback = build_callback(&block)
  end

  def edit
    @before_callback.call if @before_callback
    system "#{editor} #{@tempfile.path}"
    @after_callback.call if @after_callback
  end

  def editor
    @editor ||= ENV['EDITOR']
    @editor or raise EditorConfigureError, "set your ENV['EDITOR']"
  end

  def editor=(editor_cmd)
    @editor = editor_cmd
  end

  private
  def build_callback(&block)
    Proc.new do
      begin
        @tempfile.open
        block.call(@tempfile)
      ensure
        @tempfile.close
      end
    end
  end
end
