class ExchangeRateService
  BASE_CURRENCY = "GBP"

  RATES = {
    "GBP" => 1.0,
    "EUR" => 0.855912,
    "USD" => 0.742377
  }.freeze

  def self.to_gbp(currency)
    RATES.fetch(currency) do
      raise ArgumentError, "Unsupported currency: #{currency}"
    end
  end
end
