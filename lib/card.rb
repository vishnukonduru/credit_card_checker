# frozen_string_literal: true

# string
class String
  def i?
    !!(self =~ /\A[-+]?[0-9]+\z/)
  end
end

# card
class Card
  def initialize(card_num, limit)
    @card_number    = card_num
    @balance        = 0.0
    @limit          = 0.0
    @status         = 'Invalid'
    @is_valid       = perform_check

    @limit = limit if @status == 'Valid'
  end

  def perform_check
    valid_card = false
    if @card_number.to_s.length < 13
      puts "ERROR: Credit Cards(#{@card_number.to_s.length}) cannot be under 13 digits"
      return valid_card
    end

    if @card_number.to_s.length > 19
      puts "ERROR: Credit Cards(#{@card_number.to_s.length}) cannot be over 19 digits"
      return valid_card
    end

    if @card_number.to_s.i? != true
      puts "ERROR: Credit Cards(#{@card_number}) Must be Only Positive Numbers"
      return valid_card
    end
    number = @card_number.to_s.gsub(/\D/, '').reverse
    sum = 0
    i = 0
    number.each_char do |ch|
      n = ch.to_i
      n *= 2 if i.odd?
      n = 1 + (n - 10) if n >= 10
      sum += n
      i   += 1
    end

    valid_card = (sum % 10).zero?

    if valid_card
      puts "Valid Card(#{@card_number})"
      @status     = 'Valid'
    else
      puts "Failed Card(#{@card_number})"
      @status = 'Invalid'
    end
    valid_card
  end

  def _credit_helper(amount)
    status = 1

    begin
      new_balance = card_balance - amount.to_i

      if new_balance > @limit
        puts "ERROR: Card(#{number}) Overcredited(#{new_balance}) Limit(#{@limit})"
      else
        status = balance(new_balance)
        return 0
      end
    rescue StandardError => e
      puts "ERROR: Failed to Credit Card(#{number}) with Ex(#{e.message})"
    end

    status
  end

  def _charge_helper(amount)
    status = 1
    begin
      new_balance = amount.to_i + card_balance

      if new_balance > @limit
        puts "ERROR: Card(#{number}) Overcharged(#{new_balance}) Limit(#{@limit})"

      else

        balance(new_balance)
        return 0
      end
    rescue StandardError => e
      puts "ERROR: Failed to Charge Card(#{number}) with Ex(#{e.message})"
    end

    status
  end

  def card_balance
    @balance.to_i
  end

  def balance(new_balance)
    @balance = new_balance.to_i
  end

  def limit
    @limit.to_i
  end

  def deactivate_card
    @status = 'Invalid'
  end

  def account_status
    @status.to_s
  end

  def number
    @card_number.to_s
  end

  def valid?
    @status == 'Valid'
  end

  def invalid?
    (@status == 'Invalid' or @status == 'Failed')
  end
end
