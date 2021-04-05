# frozen_string_literal: true

require 'card'
require 'account'

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

describe Account do
  describe 'starting account has no default source' do
    context 'test that a starting account has no default source' do
      it 'by verifying the source' do
        new_account_name    = 'User'
        test_object         = Account.new(new_account_name)
        expect(test_object.default_source.account_status).to eq(Card.new('2000000000000000', 0).account_status)
        expect(test_object.default_source.limit).to eq(Card.new('2000000000000000', 0).limit)
        expect(test_object.valid?).to eq(false)

        puts 'Account Creation Supported'
      end
    end
  end

  describe 'account credit card' do
    context 'test accounts support adding a credit card' do
      it 'by adding a valid card' do
        limit               = 555
        limit_str           = "$#{limit}"
        test_object         = Account.new('User')
        test_object.add(test_credit_card_map['MasterCard'], limit_str)
        expect(test_object.default_source.account_status).to eq(Card.new(test_credit_card_map['MasterCard'],
                                                                         555).account_status)
        expect(test_object.default_source.limit).to eq(Card.new(test_credit_card_map['MasterCard'],
                                                                555).limit)
        expect(test_object.default_source.card_balance).to eq(0)

        puts 'Account Creation Supported'
      end
    end
  end
end
