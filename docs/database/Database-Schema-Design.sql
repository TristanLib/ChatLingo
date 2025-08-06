-- ChatLingo 数据库架构设计
-- 数据库版本: PostgreSQL 15+
-- 创建时间: 2024-08-06

-- 创建数据库和基础扩展
CREATE DATABASE chatlingo;
USE chatlingo;

-- 启用必要的扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 创建枚举类型
CREATE TYPE english_level AS ENUM ('A1', 'A2', 'B1', 'B2', 'C1', 'C2');
CREATE TYPE subscription_type AS ENUM ('free', 'basic', 'premium', 'enterprise');
CREATE TYPE lesson_type AS ENUM ('vocabulary', 'grammar', 'conversation', 'listening', 'reading', 'writing');
CREATE TYPE session_status AS ENUM ('active', 'completed', 'paused', 'cancelled');
CREATE TYPE content_difficulty AS ENUM ('beginner', 'intermediate', 'advanced');

-- ================================================================
-- 1. 用户相关表
-- ================================================================

-- 用户表
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(32) NOT NULL,
    
    -- 个人信息
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    avatar_url TEXT,
    date_of_birth DATE,
    timezone VARCHAR(50) DEFAULT 'UTC',
    
    -- 学习信息
    english_level english_level DEFAULT 'A1',
    native_language VARCHAR(10) DEFAULT 'zh-CN',
    learning_goals TEXT[],
    daily_goal_minutes INTEGER DEFAULT 20,
    
    -- 订阅信息
    subscription_type subscription_type DEFAULT 'free',
    subscription_start_date TIMESTAMP,
    subscription_end_date TIMESTAMP,
    auto_renewal BOOLEAN DEFAULT false,
    
    -- 统计信息
    learning_streak INTEGER DEFAULT 0,
    total_learning_time INTEGER DEFAULT 0, -- 总学习时间(秒)
    coins INTEGER DEFAULT 100,
    experience_points INTEGER DEFAULT 0,
    
    -- 系统字段
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 用户配置表
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 通知设置
    daily_reminder BOOLEAN DEFAULT true,
    reminder_time TIME DEFAULT '19:00:00',
    streak_reminders BOOLEAN DEFAULT true,
    social_notifications BOOLEAN DEFAULT true,
    learning_tips BOOLEAN DEFAULT true,
    
    -- 学习设置
    auto_play_audio BOOLEAN DEFAULT true,
    show_phonetic BOOLEAN DEFAULT true,
    speech_rate DECIMAL(3,2) DEFAULT 1.0,
    
    -- 隐私设置
    profile_public BOOLEAN DEFAULT true,
    show_in_leaderboard BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 用户设备表
CREATE TABLE user_devices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    device_token VARCHAR(255) NOT NULL,
    platform VARCHAR(20) NOT NULL, -- ios, android
    app_version VARCHAR(20),
    device_model VARCHAR(100),
    os_version VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    last_active_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 2. 学习内容表
-- ================================================================

-- 课程分类表
CREATE TABLE lesson_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_url TEXT,
    color_code VARCHAR(7), -- HEX颜色码
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 课程表
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES lesson_categories(id),
    
    -- 基础信息
    title VARCHAR(255) NOT NULL,
    description TEXT,
    content JSONB NOT NULL, -- 课程内容JSON
    
    -- 分类信息
    difficulty english_level NOT NULL,
    lesson_type lesson_type NOT NULL,
    tags TEXT[] DEFAULT '{}',
    
    -- 媒体资源
    thumbnail_url TEXT,
    audio_url TEXT,
    video_url TEXT,
    
    -- 学习信息
    estimated_duration INTEGER, -- 预估学习时长(分钟)
    prerequisite_lessons UUID[], -- 前置课程ID数组
    
    -- 权限控制
    is_premium BOOLEAN DEFAULT false,
    required_level english_level,
    
    -- 统计信息
    completion_count INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    
    -- 系统字段
    is_published BOOLEAN DEFAULT false,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 词汇表
CREATE TABLE vocabulary (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 单词信息
    word VARCHAR(100) NOT NULL UNIQUE,
    pronunciation VARCHAR(200), -- IPA音标
    word_class VARCHAR(20), -- 词性
    frequency_rank INTEGER, -- 词频排名
    
    -- 含义信息
    definitions JSONB NOT NULL, -- 多种定义
    chinese_meanings TEXT[],
    
    -- 难度信息
    difficulty_level english_level NOT NULL,
    cefr_level VARCHAR(2),
    
    -- 媒体资源
    audio_url TEXT,
    image_url TEXT,
    
    -- 关联信息
    related_words TEXT[], -- 相关词汇
    word_family TEXT[], -- 词族
    collocations TEXT[], -- 搭配
    
    -- 分类标签
    topics TEXT[] DEFAULT '{}',
    categories TEXT[] DEFAULT '{}',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 例句表
CREATE TABLE vocabulary_examples (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vocabulary_id UUID REFERENCES vocabulary(id) ON DELETE CASCADE,
    
    sentence_english TEXT NOT NULL,
    sentence_chinese TEXT,
    audio_url TEXT,
    
    -- 例句来源
    source VARCHAR(100), -- 来源(教材、真题等)
    context VARCHAR(200), -- 语境说明
    
    -- 难度和使用频率
    difficulty_level english_level,
    usage_frequency INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 3. 学习进度表
-- ================================================================

-- 学习会话表
CREATE TABLE learning_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    lesson_id UUID REFERENCES lessons(id),
    
    -- 会话信息
    session_type lesson_type NOT NULL,
    status session_status DEFAULT 'active',
    
    -- 进度信息
    current_step INTEGER DEFAULT 0,
    total_steps INTEGER,
    progress_percentage INTEGER DEFAULT 0,
    
    -- 时间信息
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    total_time_spent INTEGER DEFAULT 0, -- 秒
    
    -- 成绩信息
    final_score INTEGER,
    accuracy_rate DECIMAL(5,2),
    
    -- 会话数据
    session_data JSONB, -- 详细的会话数据
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 用户学习进度表
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
    
    -- 进度信息
    progress_percentage INTEGER DEFAULT 0,
    is_completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP,
    
    -- 成绩信息
    best_score INTEGER DEFAULT 0,
    total_attempts INTEGER DEFAULT 0,
    total_time_spent INTEGER DEFAULT 0, -- 秒
    
    -- 复习信息
    last_reviewed_at TIMESTAMP,
    review_count INTEGER DEFAULT 0,
    mastery_level DECIMAL(3,2) DEFAULT 0.0, -- 掌握程度(0-1)
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, lesson_id)
);

-- 用户词汇学习记录表
CREATE TABLE user_vocabulary_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    vocabulary_id UUID REFERENCES vocabulary(id) ON DELETE CASCADE,
    
    -- 学习状态
    learning_status VARCHAR(20) DEFAULT 'new', -- new, learning, mastered
    proficiency_level INTEGER DEFAULT 1, -- 1-5级熟练度
    
    -- 复习信息
    next_review_date DATE,
    review_count INTEGER DEFAULT 0,
    consecutive_correct INTEGER DEFAULT 0,
    
    -- 学习记录
    first_learned_at TIMESTAMP,
    last_reviewed_at TIMESTAMP,
    total_time_spent INTEGER DEFAULT 0, -- 秒
    
    -- 错误记录
    mistake_count INTEGER DEFAULT 0,
    common_mistakes JSONB, -- 常见错误记录
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, vocabulary_id)
);

-- ================================================================
-- 4. AI对话相关表
-- ================================================================

-- AI对话会话表
CREATE TABLE chat_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 对话配置
    conversation_topic VARCHAR(100),
    user_level english_level,
    conversation_type VARCHAR(50), -- practice, assessment, free_talk
    
    -- AI配置
    ai_personality VARCHAR(50), -- friendly, professional, casual
    scenario_context JSONB, -- 场景上下文
    
    -- 对话状态
    is_active BOOLEAN DEFAULT true,
    turn_count INTEGER DEFAULT 0,
    
    -- 时间信息
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    total_duration INTEGER, -- 总时长(秒)
    
    -- 评估信息
    overall_rating INTEGER, -- 1-5星评级
    feedback_given BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI对话消息表
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID REFERENCES chat_conversations(id) ON DELETE CASCADE,
    
    -- 消息信息
    sender_type VARCHAR(10) NOT NULL, -- user, ai
    message_text TEXT,
    message_type VARCHAR(20) DEFAULT 'text', -- text, audio, image
    
    -- 音频消息
    audio_url TEXT,
    audio_duration DECIMAL(5,2),
    transcription TEXT,
    
    -- 语言分析
    grammar_feedback JSONB,
    pronunciation_feedback JSONB,
    vocabulary_used TEXT[],
    
    -- AI响应信息
    ai_response_time INTEGER, -- AI响应时间(毫秒)
    ai_confidence DECIMAL(3,2), -- AI信心度
    
    -- 教学点
    teaching_points TEXT[],
    corrections JSONB,
    
    -- 时间戳
    message_order INTEGER, -- 消息顺序
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 5. 社交功能表
-- ================================================================

-- 用户关系表(关注/被关注)
CREATE TABLE user_relationships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    follower_id UUID REFERENCES users(id) ON DELETE CASCADE,
    following_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    relationship_type VARCHAR(20) DEFAULT 'follow', -- follow, block, mute
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(follower_id, following_id)
);

-- 社区动态表
CREATE TABLE social_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 内容信息
    content TEXT NOT NULL,
    post_type VARCHAR(20) DEFAULT 'text', -- text, image, achievement, tip
    
    -- 媒体内容
    image_urls TEXT[],
    
    -- 学习成就相关
    achievement_data JSONB, -- 成就数据
    learning_stats JSONB, -- 学习统计
    
    -- 可见性
    visibility VARCHAR(20) DEFAULT 'public', -- public, followers, private
    
    -- 标签
    hashtags TEXT[],
    mentioned_users UUID[],
    
    -- 统计信息
    like_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    share_count INTEGER DEFAULT 0,
    
    -- 系统字段
    is_pinned BOOLEAN DEFAULT false,
    is_featured BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 动态评论表
CREATE TABLE post_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID REFERENCES social_posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    parent_comment_id UUID REFERENCES post_comments(id), -- 回复评论
    
    content TEXT NOT NULL,
    like_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 点赞表
CREATE TABLE post_likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID REFERENCES social_posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(post_id, user_id)
);

-- 学习小组表
CREATE TABLE study_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 基础信息
    name VARCHAR(100) NOT NULL,
    description TEXT,
    avatar_url TEXT,
    
    -- 小组设置
    max_members INTEGER DEFAULT 50,
    join_policy VARCHAR(20) DEFAULT 'open', -- open, invite_only, private
    study_goal TEXT,
    target_level english_level,
    
    -- 创建者信息
    created_by UUID REFERENCES users(id),
    
    -- 统计信息
    member_count INTEGER DEFAULT 1,
    activity_score INTEGER DEFAULT 0,
    
    -- 系统字段
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 小组成员表
CREATE TABLE study_group_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id UUID REFERENCES study_groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    role VARCHAR(20) DEFAULT 'member', -- admin, moderator, member
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(group_id, user_id)
);

-- ================================================================
-- 6. 订阅和支付表
-- ================================================================

-- 订阅计划表
CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 计划信息
    plan_name VARCHAR(50) NOT NULL,
    plan_id VARCHAR(50) UNIQUE NOT NULL, -- 用于客户端识别
    
    -- 价格信息
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    billing_period VARCHAR(20), -- monthly, yearly
    
    -- Apple/Google产品ID
    apple_product_id VARCHAR(100),
    google_product_id VARCHAR(100),
    
    -- 功能描述
    features JSONB,
    limitations JSONB,
    
    -- 系统字段
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 用户订阅记录表
CREATE TABLE user_subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    plan_id UUID REFERENCES subscription_plans(id),
    
    -- 订阅状态
    status VARCHAR(20) DEFAULT 'active', -- active, expired, cancelled, pending
    
    -- 时间信息
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    cancelled_at TIMESTAMP,
    
    -- 支付信息
    payment_method VARCHAR(20), -- apple_pay, wechat, alipay
    transaction_id VARCHAR(255),
    original_transaction_id VARCHAR(255),
    
    -- 续费信息
    auto_renewal BOOLEAN DEFAULT true,
    renewal_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 支付记录表
CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    subscription_id UUID REFERENCES user_subscriptions(id),
    
    -- 交易信息
    transaction_type VARCHAR(20), -- subscription, renewal, refund
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    
    -- 外部交易信息
    external_transaction_id VARCHAR(255),
    payment_gateway VARCHAR(20), -- apple, google, stripe
    receipt_data TEXT,
    
    -- 状态信息
    status VARCHAR(20) DEFAULT 'pending', -- pending, completed, failed, refunded
    
    -- 时间戳
    processed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 7. 系统表
-- ================================================================

-- 应用配置表
CREATE TABLE app_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value JSONB,
    description TEXT,
    is_public BOOLEAN DEFAULT false, -- 是否可以通过API获取
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 通知表
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 通知内容
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50), -- reminder, achievement, social, system
    
    -- 通知数据
    action_data JSONB, -- 点击通知的动作数据
    
    -- 状态
    is_read BOOLEAN DEFAULT false,
    is_sent BOOLEAN DEFAULT false,
    
    -- 发送时间
    scheduled_at TIMESTAMP,
    sent_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 用户行为日志表
CREATE TABLE user_activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- 行为信息
    action_type VARCHAR(50) NOT NULL, -- login, lesson_start, lesson_complete, etc.
    action_details JSONB,
    
    -- 会话信息
    session_id VARCHAR(100),
    device_info JSONB,
    
    -- 位置信息
    ip_address INET,
    user_agent TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 8. 创建索引
-- ================================================================

-- 用户表索引
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_subscription ON users(subscription_type, subscription_end_date);
CREATE INDEX idx_users_level ON users(english_level);

-- 课程表索引
CREATE INDEX idx_lessons_difficulty ON lessons(difficulty);
CREATE INDEX idx_lessons_type ON lessons(lesson_type);
CREATE INDEX idx_lessons_premium ON lessons(is_premium);
CREATE INDEX idx_lessons_published ON lessons(is_published);
CREATE INDEX idx_lessons_category ON lessons(category_id);

-- 词汇表索引
CREATE INDEX idx_vocabulary_word ON vocabulary(word);
CREATE INDEX idx_vocabulary_level ON vocabulary(difficulty_level);
CREATE INDEX idx_vocabulary_frequency ON vocabulary(frequency_rank);
CREATE INDEX idx_vocabulary_topics ON vocabulary USING GIN(topics);

-- 学习进度索引
CREATE INDEX idx_progress_user_lesson ON user_progress(user_id, lesson_id);
CREATE INDEX idx_progress_completed ON user_progress(is_completed, completed_at);
CREATE INDEX idx_vocabulary_progress_user ON user_vocabulary_progress(user_id);
CREATE INDEX idx_vocabulary_progress_review ON user_vocabulary_progress(next_review_date) WHERE next_review_date IS NOT NULL;

-- 对话表索引
CREATE INDEX idx_conversations_user ON chat_conversations(user_id);
CREATE INDEX idx_conversations_active ON chat_conversations(is_active, started_at);
CREATE INDEX idx_messages_conversation ON chat_messages(conversation_id, message_order);

-- 社交表索引
CREATE INDEX idx_posts_user_time ON social_posts(user_id, created_at DESC);
CREATE INDEX idx_posts_visibility ON social_posts(visibility, created_at DESC);
CREATE INDEX idx_post_likes_post ON post_likes(post_id);
CREATE INDEX idx_post_comments_post ON post_comments(post_id, created_at);

-- 订阅表索引
CREATE INDEX idx_subscriptions_user ON user_subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON user_subscriptions(status, expires_at);
CREATE INDEX idx_transactions_user ON payment_transactions(user_id, created_at DESC);

-- 通知表索引
CREATE INDEX idx_notifications_user ON notifications(user_id, is_read, created_at DESC);
CREATE INDEX idx_notifications_scheduled ON notifications(scheduled_at) WHERE scheduled_at IS NOT NULL;

-- 日志表索引
CREATE INDEX idx_activity_logs_user ON user_activity_logs(user_id, created_at DESC);
CREATE INDEX idx_activity_logs_action ON user_activity_logs(action_type, created_at DESC);

-- ================================================================
-- 9. 创建触发器和函数
-- ================================================================

-- 更新updated_at字段的函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为相关表创建更新触发器
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_preferences_updated_at BEFORE UPDATE ON user_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lessons_updated_at BEFORE UPDATE ON lessons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_progress_updated_at BEFORE UPDATE ON user_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vocabulary_progress_updated_at BEFORE UPDATE ON user_vocabulary_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sessions_updated_at BEFORE UPDATE ON learning_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON social_posts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================================
-- 10. 视图定义
-- ================================================================

-- 用户学习统计视图
CREATE VIEW user_learning_stats AS
SELECT 
    u.id as user_id,
    u.username,
    u.english_level,
    u.learning_streak,
    u.total_learning_time,
    u.coins,
    u.experience_points,
    COUNT(DISTINCT up.lesson_id) as lessons_started,
    COUNT(DISTINCT CASE WHEN up.is_completed THEN up.lesson_id END) as lessons_completed,
    COUNT(DISTINCT uvp.vocabulary_id) as vocabulary_learned,
    COUNT(DISTINCT cc.id) as conversation_count,
    COALESCE(AVG(up.best_score), 0) as average_score
FROM users u
LEFT JOIN user_progress up ON u.id = up.user_id
LEFT JOIN user_vocabulary_progress uvp ON u.id = uvp.user_id
LEFT JOIN chat_conversations cc ON u.id = cc.user_id
GROUP BY u.id, u.username, u.english_level, u.learning_streak, 
         u.total_learning_time, u.coins, u.experience_points;

-- 课程完成统计视图
CREATE VIEW lesson_completion_stats AS
SELECT 
    l.id as lesson_id,
    l.title,
    l.difficulty,
    l.lesson_type,
    COUNT(up.user_id) as total_attempts,
    COUNT(CASE WHEN up.is_completed THEN 1 END) as completions,
    CASE 
        WHEN COUNT(up.user_id) > 0 
        THEN ROUND((COUNT(CASE WHEN up.is_completed THEN 1 END) * 100.0 / COUNT(up.user_id)), 2)
        ELSE 0 
    END as completion_rate,
    AVG(up.best_score) as average_score,
    AVG(up.total_time_spent) as average_time_spent
FROM lessons l
LEFT JOIN user_progress up ON l.id = up.lesson_id
GROUP BY l.id, l.title, l.difficulty, l.lesson_type;

-- 每日活跃用户统计视图
CREATE VIEW daily_active_users AS
SELECT 
    DATE(ual.created_at) as activity_date,
    COUNT(DISTINCT ual.user_id) as daily_active_users,
    COUNT(DISTINCT CASE WHEN ual.action_type = 'lesson_complete' THEN ual.user_id END) as users_completed_lessons,
    COUNT(DISTINCT CASE WHEN ual.action_type = 'chat_message' THEN ual.user_id END) as users_used_chat
FROM user_activity_logs ual
WHERE ual.created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(ual.created_at)
ORDER BY activity_date DESC;

-- ================================================================
-- 11. 初始化数据
-- ================================================================

-- 插入默认配置
INSERT INTO app_configs (config_key, config_value, description, is_public) VALUES
('app_version', '"1.0.0"', '应用版本号', true),
('maintenance_mode', 'false', '维护模式', true),
('ai_chat_rate_limit', '{"free": 10, "basic": 30, "premium": 100}', 'AI对话频率限制', false),
('daily_goal_default', '20', '默认每日学习目标(分钟)', true),
('supported_languages', '["zh-CN", "en-US"]', '支持的语言列表', true);

-- 插入课程分类
INSERT INTO lesson_categories (name, description, icon_url, color_code, sort_order) VALUES
('日常英语', '日常生活中的英语表达', '/icons/daily.png', '#4CAF50', 1),
('商务英语', '职场和商务场景的英语', '/icons/business.png', '#2196F3', 2),
('考试英语', '雅思、托福等考试准备', '/icons/exam.png', '#FF9800', 3),
('旅游英语', '旅行和观光相关英语', '/icons/travel.png', '#9C27B0', 4),
('学术英语', '学术写作和研究英语', '/icons/academic.png', '#795548', 5);

-- 插入订阅计划
INSERT INTO subscription_plans (plan_name, plan_id, price, currency, billing_period, apple_product_id, features) VALUES
('基础会员', 'basic_monthly', 39.00, 'CNY', 'monthly', 'com.chatlingo.basic.monthly', 
 '{"unlimited_learning": true, "basic_content": true, "community_access": true}'),
('高级会员', 'premium_monthly', 79.00, 'CNY', 'monthly', 'com.chatlingo.premium.monthly',
 '{"unlimited_learning": true, "premium_content": true, "ai_chat_unlimited": true, "tutor_access": true, "analytics": true}'),
('年费会员', 'premium_yearly', 399.00, 'CNY', 'yearly', 'com.chatlingo.premium.yearly',
 '{"unlimited_learning": true, "premium_content": true, "ai_chat_unlimited": true, "tutor_access": true, "analytics": true, "yearly_discount": true}');

-- 创建数据库备份和恢复脚本注释
-- 备份命令: pg_dump -h localhost -U username chatlingo > chatlingo_backup.sql
-- 恢复命令: psql -h localhost -U username chatlingo < chatlingo_backup.sql

-- ================================================================
-- 12. 性能优化建议
-- ================================================================

-- 1. 定期分析表统计信息
-- ANALYZE users, lessons, user_progress, chat_conversations;

-- 2. 清理历史日志数据 (保留3个月)
-- DELETE FROM user_activity_logs WHERE created_at < CURRENT_DATE - INTERVAL '90 days';

-- 3. 重建索引 (必要时)
-- REINDEX INDEX CONCURRENTLY idx_users_email;

-- 4. 分区建议 (大数据量时)
-- 可考虑对user_activity_logs表按月分区
-- 可考虑对chat_messages表按对话ID分区

-- 结束脚本