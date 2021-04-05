# frozen_string_literal: true

require 'account'

# PaymentProcessor
class PaymentProcessor
  def initialize
    @accounts = {}
  end

  def add(name, new_card_str, limit_str)
    status = 1
    if @accounts.key?(name)
      puts "Already have Account(#{name})"
    else
      @accounts[name] = Account.new(name)
    end

    if @accounts[name].cards.key?(new_card_str) == false
      status = @accounts[name].add(new_card_str, limit_str)
    else
      puts "\tAccount(#{name}) already has Card(#{new_card_str})"
    end

    status
  end

  def credit(name, amount_str, new_card_str = '0')
    status = 1
    if @accounts.key?(name)
      status = @accounts[name].credit(amount_str, new_card_str)
    else
      puts "No Account(#{name})"
    end
    status
  end

  def charge(name, amount_str, new_card_str = '0')
    status = 1
    if @accounts.key?(name)
      status = @accounts[name].charge(amount_str, new_card_str)
    else
      puts "No Account(#{name})"
    end
    status
  end

  def process_action(org_line)
    line    = org_line.to_s.chomp
    args    = line.split(' ')
    if args.length.positive?
      case args[0]
      when 'Add'
        if args.length == 4
          add(args[1].to_s, args[2].to_s, args[3].to_s)
        else
          puts "ERROR: Add - Unsupported Number of Arguments(#{args}) Length(#{args.length})"
        end

      when 'Charge'
        if args.length == 3
          charge(args[1].to_s, args[2].to_s, '0')
        else
          puts "ERROR: Charge - Unsupported Number of Arguments(#{args}) Length(#{args.length})"
        end
      when 'Credit'
        if args.length == 3
          credit(args[1].to_s, args[2].to_s, '0')
        else
          puts "ERROR: Credit - Unsupported Number of Arguments(#{args}) Length(#{args.length})"
        end
      else
        puts "ERROR: Unsupported Action(#{args[0]})"
      end
    else
      puts "ERROR: Missing Action(#{org_line})"
    end
  end

  def run_report
    summary_report = ''
    Hash[@accounts.sort].each do |name, acc|
      cur_line = "\n"
      cur_line += acc.valid? ? "#{name}: $#{acc.default_source.card_balance.to_i}\n" : "#{name}: #{acc.status}\n"
      summary_report += cur_line
    end
    summary_report
  end
end
