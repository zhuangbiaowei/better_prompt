# Better Prompt

一个与[smart_prompt](https://github.com/zhuangbiaowei/smart_prompt)配合使用的Ruby Gem，用于记录和分析大模型提示词交互。

## 功能特性

- 完整记录提示词/响应历史，包括：
  - 提示词内容和长度
  - 响应内容、长度和响应时间
  - 模型信息（名称、提供商、大小）
  - 调用参数（temperature, max_tokens等）
  - 流式与非流式调用
- 存储用户对响应质量的评价：
  - 星级评分（1-5）
  - 详细评分（准确性、相关性等）
  - 自由评论
- 提示词组织功能：
  - 标签和分类
  - 项目分组
- 使用SQLite数据库便于分析
- 字符界面分析日志和比较响应：
  - 执行 `better_prompt ./path/database.db` 启动
  - 查看交互日志和历史记录
  - 并排比较不同模型的响应
  - 评估和评分响应质量
  - 使用[ruby_rich](https://github.com/zhuangbiaowei/ruby_rich)构建的丰富终端界面

## 数据库结构

数据库包含以下主要表：

1. `users` - 用户账户
2. `models` - 大模型信息
3. `prompts` - 提示词内容和元数据
4. `model_calls` - 单个API调用
5. `responses` - 模型响应
6. `feedback` - 用户评分和评论
7. `tags`/`prompt_tags` - 提示词分类
8. `projects`/`project_prompts` - 提示词组织

完整结构请查看[db/init.sql](db/init.sql)。

## 安装

添加到Gemfile:

```ruby
gem 'better_prompt'
```

然后执行:

```bash
bundle install
```

## 使用

基本设置:

```ruby
require 'better_prompt'

# 初始化数据库路径
BetterPrompt.setup(db_path: 'path/to/database.db')

# 记录提示词和响应
BetterPrompt.record(
  user_id: 1,
  prompt: "解释量子计算",
  response: "量子计算使用量子比特...", 
  model_name: "gpt-4",
  response_time_ms: 1250,
  is_stream: false
)

# 添加用户反馈
BetterPrompt.add_feedback(
  response_id: 123,
  rating: 4,
  comment: "有帮助但可以更详细"
)
```

## 开发

克隆仓库后:

```bash
bin/setup
bundle exec rake test
```

## 贡献

欢迎提交错误报告和拉取请求。

## 许可证

本项目采用MIT开源许可证。