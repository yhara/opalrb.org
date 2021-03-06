require 'opal'
require 'opal-parser'
require 'opal-jquery'

DEFAULT_TRY_CODE = <<-RUBY
class Foo
  attr_accessor :name

  def method_missing(sym, *args, &block)
    puts "You tried to call: \#{sym}"
  end
end

adam = Foo.new
adam.name = 'Adam Beynon'
puts adam.name
adam.do_task
RUBY

class TryOpal
  class Editor
    def initialize(dom_id, options)
      @native = `CodeMirror(document.getElementById(dom_id), #{options.to_n})`
    end

    def value=(str)
      `#@native.setValue(str)`
    end

    def value
      `#@native.getValue()`
    end
  end

  def self.instance
    @instance ||= self.new
  end

  def initialize
    @flush = []

    @output = Editor.new :output, lineNumbers: false, mode: 'javascript', readOnly: true
    @viewer = Editor.new :viewer, lineNumbers: true, mode: 'javascript', readOnly: true
    @editor = Editor.new :editor, lineNumbers: true, mode: 'ruby', tabMode: 'shift'

    @link = Element.find('#link_code')
    Element.find('#run_code').on(:click) { run_code }

    hash = `decodeURIComponent(location.hash)`

    if hash.start_with? '#code:'
      @editor.value = hash[6..-1]
    else
      @editor.value = DEFAULT_TRY_CODE.strip
    end
  end

  def run_code
    @flush = []
    @output.value = ''

    @link[:href] = "#code:#{`encodeURIComponent(#{@editor.value})`}"

    begin
      code = Opal.compile(@editor.value, :source_map_enabled => false)
      @viewer.value = code
      eval_code code
    rescue => err
      log_error err
    end
  end

  def eval_code(js_code)
    `eval(js_code)`
  end

  def log_error(err)
    print_to_output "#{err}\n#{`err.stack`}"
  end

  def print_to_output(str)
    @flush << str
    @output.value = @flush.join("\n")
  end
end

Document.ready? do
  def $stdout.puts(*strs)
    strs.each { |str| TryOpal.instance.print_to_output str }
  end

  TryOpal.instance.run_code
end
