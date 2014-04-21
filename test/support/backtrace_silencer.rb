class BacktraceFilter
  def filter(bt)
    return ['No backtrace'] unless bt

    return bt.dup if $DEBUG

    bt.select do |line|
      line.include?(root) || line =~ /\Atest/
    end
  end

  def root
    File.dirname File.expand_path('../../', __FILE__)
  end
end

MiniTest.backtrace_filter = BacktraceFilter.new
