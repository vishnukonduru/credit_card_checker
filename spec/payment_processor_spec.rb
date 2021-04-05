# frozen_string_literal: true

require 'card'
require 'account'
require 'payment_processor'

new_processor = PaymentProcessor.new

describe PaymentProcessor do
  describe 'add' do
    new_processor.add('Greg', '4111111111111111', '$1000')
  end

  describe 'credit' do
    new_processor.credit('Greg', '$500')
  end

  describe 'credit' do
    context 'try to credit an inactive card' do
      it 'credit an inactive card' do
        expect(new_processor.credit('Greg', '$500', 'NOT A REAL CARD')).to be 1
      end
    end
  end

  describe 'summary' do
    new_processor.run_report
  end

  describe 'charge' do
    it 'charge card' do
      expect(new_processor.charge('Greg', '$800')).to be 0
    end
  end
end
