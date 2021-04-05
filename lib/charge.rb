# frozen_string_literal: true

# charge
class Charge
  attr_accessor :account

  def initialize(default_source, name, account)
    @default_source = default_source
    @name = name
    @account = account
  end

  def charge(amount_str, card_str = '0')
    status = 1
    if account.cards.length.positive?
      amount      = account.convert_amount_to_float(amount_str)
      target_card = nil
      if (@default_source.to_s != '-1') && (card_str == '0') && account.cards[@default_source].valid?
        target_card = account.cards[@default_source]
      elsif account.cards.key?(card_str)
        if account.cards[card_str].valid?
          target_card = account.cards[card_str]
        else
          puts "ERROR: Name(#{@name}) Does not have Valid Card(#{card_str})"
        end
      else
        puts "ERROR: Name(#{@name}) Does not have Card(#{card_str})"
      end
      return status if target_card.nil?

      status = target_card._charge_helper(amount)
    else
      puts "ERROR: Account(#{@name}) has no valid credit cards"
    end
    status
  end
end
