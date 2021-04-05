# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'card'
require 'account'
require 'payment_processor'

processor = PaymentProcessor.new

if ARGV.length >= 1
  path_to_file = ''
  begin
    path_to_file = ARGV[0].to_s
    if File.file?(path_to_file)

      File.open(path_to_file, 'r') do |f|
        f.each_line do |line|
          processor.process_action(line)
        end
      end
      current_summary = processor.run_report.to_s
      puts current_summary

    else
      puts "\nERROR: File Does Not Exist(#{path_to_file})\n\tPlease confirm it exists"
      puts usage_printout
    end
  rescue StandardError => e
    puts "\nERROR: Failed to Handle Arguments with Ex(#{e.message})\n"
    0
  end

else
  puts ''
  puts 'Starting Interactive Shell Mode Please Type the Commands:'
  puts ''

  while (line = gets)
    break if line.to_s.chomp == ''

    processor.process_action(line.chomp)
  end

  current_summary = processor.run_report.to_s
  puts current_summary
end
