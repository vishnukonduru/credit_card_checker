# frozen_string_literal: true

require 'card'
test_credit_card_map = {
  'American Express' => '378282246310005',
  'American Express 2' => '371449635398431',
  'American Express Corporate' => '378734493671000',
  'Australian BankCard' => '5610591081018250',
  'Diners Club' => '30569309025904',
  'Diners Club 2' => '38520000023237',
  'Discover' => '6011111111111117',
  'Discover 2' => '6011000990139424',
  'JCB' => '3530111333300000',
  'JCB 2' => '3566002020360505',
  'MasterCard' => '5555555555554444',
  'MasterCard 2' => '5105105105105100',
  'Visa' => '4111111111111111',
  'Visa 2' => '4012888888881881',
  'Visa 3' => '4222222222222'
}

test_object = Card.new(test_credit_card_map['American Express'], 0.0)

describe 'perform 10 check' do
  it 'by iterating over the map' do
    test_credit_card_map.each do |key, val|
      test_object = Card.new(val, 0.0)
      puts "Testing Key(#{key}) Value(#{val})"
      expect(test_object.perform_check).to be true
      expect(test_object.valid?).to be true
      expect(test_object.invalid?).to be false
    end
  end
end

describe 'valid starting limit' do
  context 'test that credit card limits are supported' do
    it 'by verifying the limit' do
      card_number         = test_credit_card_map['Visa'].to_s
      limit               = 200.0
      test_object         = Card.new(card_number, limit)
      expect(test_object.limit.to_i).to eq(limit.to_i)
      puts 'Card Starting Limits Passed'
    end
  end
end

describe 'valid starting balance' do
  context 'test that credit card balance are supported' do
    it 'by verifying the balance' do
      card_number         = test_credit_card_map['Visa'].to_s
      limit               = 300.0
      test_object         = Card.new(card_number, limit)
      expect(test_object.card_balance.to_i).to eq(0.to_i)

      puts 'Card Starting Balances Passed'
    end
  end
end

describe 'charges work' do
  context 'test that credit card charges increase the balance' do
    it 'by verifying the balance and limit' do
      card_number         = test_credit_card_map['Visa'].to_s
      limit               = 400.0
      test_object         = Card.new(card_number, limit)
      expect(test_object.limit).to eq(limit.to_i)
      expect(test_object.card_balance).to eq(0.to_i)

      current_balance     = test_object.card_balance
      current_charge      = 100
      test_object._charge_helper(current_charge)
      expect(test_object.limit).to eq(limit.to_i)
      expect(test_object.card_balance).to eq(current_balance + current_charge)

      current_balance     = test_object.card_balance
      current_charge      = 200
      test_object._charge_helper(current_charge)
      expect(test_object.limit).to eq(limit.to_i)
      expect(test_object.card_balance).to eq(current_balance + current_charge)

      puts 'Card Charges Passed'
    end
  end
end

describe 'charges work up to the limit' do
  context 'test that credit card charges increase the balance to the limit' do
    it 'by verifying the balance and limit' do
      card_number         = test_credit_card_map['Visa'].to_s
      limit               = 400.0
      test_object         = Card.new(card_number, limit)
      expect(test_object.limit).to eq(limit.to_i)
      expect(test_object.card_balance).to eq(0.to_i)

      current_balance     = test_object.card_balance
      current_charge      = 100
      test_object._charge_helper(current_charge)
      expect(test_object.limit).to eq(limit.to_i)
      expect(test_object.card_balance).to eq(current_balance + current_charge)

      current_balance     = test_object.card_balance
      current_charge      = 200
      test_object._charge_helper(current_charge)
      expect(test_object.limit).to eq(limit.to_i)
      expect(test_object.card_balance).to eq(current_balance + current_charge)

      # This will overcharge the card
      current_balance     = test_object.card_balance
      current_charge      = 200
      test_object._charge_helper(current_charge)
      expect(test_object.limit).to eq(limit.to_i)
      expect(test_object.card_balance).to eq(current_balance)

      puts 'Card Charges Passed - Hit Limit'
    end
  end
end
