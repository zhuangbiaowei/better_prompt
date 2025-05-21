-- 创建用户表
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME
);

-- 创建模型表
CREATE TABLE models (
    model_id INTEGER PRIMARY KEY AUTOINCREMENT,
    model_name TEXT NOT NULL,
    model_provider TEXT NOT NULL,
    model_size TEXT,
    model_version TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 创建提示词表
CREATE TABLE prompts (
    prompt_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    prompt_content TEXT NOT NULL,
    prompt_length INTEGER NOT NULL,
    prompt_language TEXT,
    prompt_category TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 创建调用记录表
CREATE TABLE model_calls (
    call_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    prompt_id INTEGER,
    model_id INTEGER,
    is_streaming INTEGER NOT NULL, -- 在SQLite中使用0/1代替布尔值
    temperature REAL,
    max_tokens INTEGER,
    top_p REAL,
    top_k INTEGER,
    additional_parameters TEXT, -- 使用JSON字符串存储
    call_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (prompt_id) REFERENCES prompts(prompt_id),
    FOREIGN KEY (model_id) REFERENCES models(model_id)
);

-- 创建响应表
CREATE TABLE responses (
    response_id INTEGER PRIMARY KEY AUTOINCREMENT,
    call_id INTEGER,
    response_content TEXT NOT NULL,
    response_length INTEGER NOT NULL,
    response_time_ms INTEGER NOT NULL, -- 响应时间(毫秒)
    token_count INTEGER,               -- 令牌数量
    cost REAL,                         -- 调用成本
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (call_id) REFERENCES model_calls(call_id)
);

-- 创建用户评价表
CREATE TABLE feedback (
    feedback_id INTEGER PRIMARY KEY AUTOINCREMENT,
    response_id INTEGER,
    user_id INTEGER,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5), -- 1-5星评价
    feedback_comment TEXT,
    accuracy_score INTEGER CHECK (accuracy_score BETWEEN 1 AND 10),
    relevance_score INTEGER CHECK (relevance_score BETWEEN 1 AND 10),
    creativity_score INTEGER CHECK (creativity_score BETWEEN 1 AND 10),
    helpfulness_score INTEGER CHECK (helpfulness_score BETWEEN 1 AND 10),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (response_id) REFERENCES responses(response_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 创建标签表，用于更好地分类提示词
CREATE TABLE tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 创建提示词-标签关联表
CREATE TABLE prompt_tags (
    prompt_id INTEGER,
    tag_id INTEGER,
    PRIMARY KEY (prompt_id, tag_id),
    FOREIGN KEY (prompt_id) REFERENCES prompts(prompt_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

-- 创建提示词标签值表 (SQLite不支持数组类型，需要额外的表)
CREATE TABLE prompt_tag_values (
    prompt_id INTEGER,
    tag_value TEXT,
    FOREIGN KEY (prompt_id) REFERENCES prompts(prompt_id)
);

-- 创建项目表，用于组织多个相关提示词
CREATE TABLE projects (
    project_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    project_name TEXT NOT NULL,
    project_description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 创建项目-提示词关联表
CREATE TABLE project_prompts (
    project_id INTEGER,
    prompt_id INTEGER,
    PRIMARY KEY (project_id, prompt_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (prompt_id) REFERENCES prompts(prompt_id)
);

-- 创建索引以提高查询性能
CREATE INDEX idx_prompts_user_id ON prompts(user_id);
CREATE INDEX idx_model_calls_user_id ON model_calls(user_id);
CREATE INDEX idx_model_calls_prompt_id ON model_calls(prompt_id);
CREATE INDEX idx_responses_call_id ON responses(call_id);
CREATE INDEX idx_feedback_response_id ON feedback(response_id);
CREATE INDEX idx_prompt_tags_prompt_id ON prompt_tags(prompt_id);
CREATE INDEX idx_project_prompts_project_id ON project_prompts(project_id);