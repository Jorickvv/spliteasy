require "test_helper"

class ExchangeRateServiceTest < ActiveSupport::TestCase
  test "GBP has exchange rate of 1" do
    assert_equal 1.0, ExchangeRateService.to_gbp("GBP")
  end

  test "EUR returns the configured rate" do
    assert_equal 0.855912, ExchangeRateService.to_gbp("EUR")
  end

  test "USD returns the configured rate" do
   assert_equal 0.742377, ExchangeRateService.to_gbp("USD")
  end

  test "unsupported currency raises an error" do
    assert_raises(ArgumentError) do
      ExchangeRateService.to_gbp("JPY")
    end
  end
end
