# Better Prompt

A Ruby Gem for tracking and analyzing LLM prompt interactions, designed to work with [smart_prompt](https://github.com/zhuangbiaowei/smart_prompt).

## Features

- Records complete prompt/response history including:
  - Prompt content and length
  - Response content, length and timing
  - Model information (name, provider, size)
  - Call parameters (temperature, max_tokens, etc.)
  - Stream vs non-stream calls
- Stores user feedback on response quality:
  - Star ratings (1-5)
  - Detailed scores (accuracy, relevance, etc.)
  - Free-form comments
- Organizes prompts with:
  - Tags and categories
  - Projects grouping
- SQLite backend for easy analysis
- Character interface for analyzing logs and comparing responses:
  - Execute `better_prompt ./path/database.db` to launch
  - View interaction logs and history
  - Compare different model responses side-by-side
  - Evaluate and rate response quality
  - Built with [ruby_rich](https://github.com/zhuangbiaowei/ruby_rich) for rich terminal UI

## Database Schema

The database contains these main tables:

1. `users` - User accounts
2. `models` - LLM model information
3. `prompts` - Prompt content and metadata
4. `model_calls` - Individual API calls
5. `responses` - Model responses
6. `feedback` - User ratings and comments
7. `tags`/`prompt_tags` - Prompt categorization
8. `projects`/`project_prompts` - Prompt organization

See [db/init.sql](db/init.sql) for complete schema.

## Installation

Add to your Gemfile:

```ruby
gem 'better_prompt'
```

Then execute:

```bash
bundle install
```

## Usage

Basic setup:

```ruby
require 'better_prompt'

# Initialize with database path
BetterPrompt.setup(db_path: 'path/to/database.db')

# Record a prompt and response
BetterPrompt.record(
  user_id: 1,
  prompt: "Explain quantum computing",
  response: "Quantum computing uses qubits...", 
  model_name: "gpt-4",
  response_time_ms: 1250,
  is_stream: false
)

# Add user feedback
BetterPrompt.add_feedback(
  response_id: 123,
  rating: 4,
  comment: "Helpful but could be more detailed"
)
```

## Development

After checking out the repo:

```bash
bin/setup
bundle exec rake test
```

## Contributing

Bug reports and pull requests are welcome.

## License

The gem is available as open source under MIT License.