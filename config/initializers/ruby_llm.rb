RubyLLM.configure do |config|
  config.openai_api_key = ENV["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"]
  config.openai_api_base = "https://models.inference.ai.azure.com"
  # ... see RubyLLM configuration guide for other models
end
