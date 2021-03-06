require "minitest"

module Rails
  class TestUnitReporter < Minitest::StatisticsReporter
    def report
      return if results.empty?
      io.puts
      io.puts "Failed tests:"
      io.puts
      io.puts aggregated_results
    end

    def aggregated_results # :nodoc:
      filtered_results = results.dup
      filtered_results.reject!(&:skipped?) unless options[:verbose]
      filtered_results.map do |result|
        location, line = result.method(result.name).source_location
        "bin/rails test #{relative_path_for(location)}:#{line}"
      end.join "\n"
    end

    def relative_path_for(file)
      file.sub(/^#{Rails.root}\/?/, '')
    end
  end
end
