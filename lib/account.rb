# frozen_string_literal: true

require 'card'
require 'charge'

# account.rb
class Account
  attr_accessor :cards, :name, :status

  def initialize(name)
    @name               = name
    @cards              = {}
    @account_balance    = 0.0
    @account_limit      = 0.0
    @default_source     = '-1'
    @status             = 'Valid'
  end

  def default_source
    unless @cards.length.positive? && (@default_source.to_s != '-1') && @cards[@default_source].valid?
      return Card.new('2000000000000000',
                      0)
    end
    return @cards[@default_source] if @cards.key?(@default_source)

    puts "Failed to find default source(#{@default_source})"
    Card.new('1000000000000000', 0)
  end

  def check_balance_conditions(_card_num, new_balance)
    @account_balance = new_balance
  end

  def convert_amount_to_float(amount_str)
    amount_str[1..-1].to_f
  end

  def add(card_str, limit_str)
    limit       = convert_amount_to_float(limit_str)
    new_card    = Card.new(card_str, limit)
    if new_card.valid?
      @cards[card_str]        = new_card
      if @default_source.to_s == '-1'
        @account_balance    = 0.0
        @account_limit      = 0.0
      end
      @default_source     = card_str
      @status             = 'Valid'
    else
      @default_source     = '-1'
      @status             = 'error'
    end
  rescue StandardError => e
    puts "ERROR: Card(#{card_str}) with Ex(#{e.message})"
  end

  def credit(amount_str, card_str = '0')
    status = 1
    if @cards.length.positive?
      amount          = convert_amount_to_float(amount_str)
      target_card     = nil
      if (@default_source.to_s != '-1') && (card_str == '0') && @cards[@default_source].valid?
        target_card = @cards[@default_source]
      elsif @cards.key?(card_str)
        if @cards[card_str].valid?
          target_card = @cards[card_str]
        else
          puts "ERROR: Name(#{@name}) Does not have Valid Card(#{card_str})"
        end
      else
        puts "ERROR: Name(#{@name}) Does not have Card(#{card_str})"
      end
      return status if target_card.nil?

      target_card._credit_helper(amount)

    else
      puts "ERROR: Account(#{@name}) has no valid credit cards"
    end
    status
  end

  def charge(amount_str, card_str = '0')
    Charge.new(@default_source, @name, self).charge(amount_str, card_str)
  end

  def account_status
    @status
  end

  def valid?
    @status == 'Valid' and @cards.length.positive?
  end
end
