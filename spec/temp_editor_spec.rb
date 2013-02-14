# -*- encoding: utf-8 -*-
require 'spec_helper'

describe TempEditor do
  shared_context "setup common @temp_editor instance" do
    before do
      @temp_editor = TempEditor.new('tempfile_prefix')

      @editor_inputs = 'my editor inputs'

      mock_editor_command = "echo '#{@editor_inputs}' >"
      @temp_editor.editor = mock_editor_command
    end
  end


  describe "#edit" do
    include_context "setup common @temp_editor instance"

    it "should exec editor" do
      begin
        @temp_editor.edit

        @temp_editor.tempfile.open
        tempfile_contents = @temp_editor.tempfile.read.chomp
        tempfile_contents.should == @editor_inputs
      ensure
        @temp_editor.tempfile.close
      end
    end
  end


  describe "#before" do
    include_context "setup common @temp_editor instance"

    it "should be called with opened tempfile" do
      @temp_editor.before do |file|
        file.should_not be_closed
      end

      @temp_editor.edit
    end

    it "should be called before edit" do
      @temp_editor.before do |file|
        file_contents = file.read
        file_contents.should be_empty
      end

      @temp_editor.edit
    end
  end


  describe "#after" do
    include_context "setup common @temp_editor instance"

    it "should be called with opened tempfile" do
      @temp_editor.after do |file|
        file.should_not be_closed
      end

      @temp_editor.edit
    end

    it "should be called after edit" do
      @temp_editor.after do |file|
        file_contents = file.read.chomp
        file_contents.should == @editor_inputs
      end

      @temp_editor.edit
    end
  end


  describe "#editor", "#editor=" do
    context "specify editor command" do
      before do
        @temp_editor = TempEditor.new('tempfile_prefix')

        @specified_editor_command_inputs = "specified editor inputs"

        @temp_editor.editor = "echo '#{@specified_editor_command_inputs}' >"
      end

      it "should use specified editor command" do
        begin
          @temp_editor.edit

          @temp_editor.tempfile.open
          tempfile_contents = @temp_editor.tempfile.read.chomp
          tempfile_contents.should == @specified_editor_command_inputs
        ensure
          @temp_editor.tempfile.close
        end
      end
    end

    context "not specify editor command" do
      before do
        @temp_editor = TempEditor.new('tempfile_prefix')
      end

      it "should use ENV['EDITOR'] as default" do
        begin
          orignal_env_editor = ENV['EDITOR']
          editor_inputs = "original editor inputs"
          ENV['EDITOR'] = "echo '#{editor_inputs}' > "

          @temp_editor.edit

          @temp_editor.tempfile.open
          tempfile_contents = @temp_editor.tempfile.read.chomp
          tempfile_contents.should == editor_inputs
        ensure
          ENV['EDITOR'] = orignal_env_editor
          @temp_editor.tempfile.close
        end
      end
    end

    context "when blank ENV['EDITOR']" do
      before do
        @temp_editor = TempEditor.new('tempfile_prefix')
      end

      it "should use ENV['EDITOR'] as default" do
        begin
          orignal_env_editor = ENV.delete('EDITOR')
          expect {
            @temp_editor.edit
          }.to raise_error(TempEditor::EditorConfigureError)
        ensure
          ENV['EDITOR'] = orignal_env_editor
        end
      end
    end
  end
end
