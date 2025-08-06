-- ChatLingo 增强版数据库架构 - 支持必会专题 + AI功能
-- 数据库版本: PostgreSQL 15+
-- 创建时间: 2024年8月6日

-- 启用必要的扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "vector"; -- 用于AI向量搜索

-- 创建新的枚举类型
CREATE TYPE essential_category AS ENUM (
    'junior_high', 'senior_high', 'cet4', 'cet6', 'postgraduate', 
    'daily_life', 'business', 'travel', 'academic', 'ielts', 'toefl'
);

CREATE TYPE essential_content_type AS ENUM (
    'vocabulary', 'passages', 'dialogues', 'grammar', 'writing_templates', 
    'listening_exercises', 'pronunciation_drills'
);

CREATE TYPE mastery_level AS ENUM ('unknown', 'learning', 'familiar', 'mastered', 'expert');
CREATE TYPE ai_feedback_type AS ENUM ('grammar', 'vocabulary', 'pronunciation', 'fluency', 'coherence');
CREATE TYPE content_difficulty AS ENUM ('beginner', 'elementary', 'intermediate', 'upper_intermediate', 'advanced');

-- ================================================================
-- 1. 必会专题核心表
-- ================================================================

-- 必会分类表
CREATE TABLE essential_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 基础信息
    category_key essential_category UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    display_name_cn VARCHAR(100) NOT NULL,
    display_name_en VARCHAR(100) NOT NULL,
    description TEXT,
    
    -- 分类特征
    target_level VARCHAR(20) NOT NULL, -- A1-A2, B1-B2, C1-C2
    age_group VARCHAR(20), -- 13-16, 18-25, etc.
    difficulty_color VARCHAR(7), -- HEX color code
    icon_url TEXT,
    background_image_url TEXT,
    
    -- 内容统计
    total_vocabulary_count INTEGER DEFAULT 0,
    total_passages_count INTEGER DEFAULT 0,
    total_dialogues_count INTEGER DEFAULT 0,
    total_grammar_points INTEGER DEFAULT 0,
    
    -- 学习预估
    estimated_duration_days INTEGER,
    estimated_daily_minutes INTEGER DEFAULT 30,
    
    -- 系统信息
    sort_order INTEGER DEFAULT 0,
    is_popular BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 必会内容表（统一存储各类必会内容）
CREATE TABLE essential_contents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES essential_categories(id) ON DELETE CASCADE,
    
    -- 内容基础信息
    content_type essential_content_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    content_key VARCHAR(100), -- 用于排序和引用
    
    -- 内容主体
    content_data JSONB NOT NULL, -- 存储具体内容数据
    metadata JSONB, -- 额外元数据
    
    -- 分类和难度
    difficulty_level content_difficulty NOT NULL,
    sub_category VARCHAR(50), -- 子分类，如"四级词汇"、"六级词汇"
    tags TEXT[] DEFAULT '{}',
    
    -- 学习相关
    estimated_learn_time INTEGER, -- 预估学习时间(分钟)
    frequency_rank INTEGER, -- 使用频率排名
    importance_score INTEGER DEFAULT 50, -- 重要性评分 1-100
    
    -- 关联信息
    prerequisite_content_ids UUID[], -- 前置内容ID数组
    related_content_ids UUID[], -- 相关内容ID数组
    
    -- 媒体资源
    audio_url TEXT,
    image_url TEXT,
    video_url TEXT,
    
    -- AI增强
    ai_generated_examples JSONB, -- AI生成的例句、对话等
    ai_difficulty_prediction DECIMAL(3,2), -- AI预测的难度系数
    ai_embedding VECTOR(1536), -- OpenAI embedding for similarity search
    
    -- 统计信息
    total_learners INTEGER DEFAULT 0,
    completion_rate DECIMAL(5,2) DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0,
    
    -- 系统字段
    created_by UUID, -- 内容创建者
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 必会词汇详细表（继承essential_contents，但有专门字段）
CREATE TABLE essential_vocabulary (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES essential_contents(id) ON DELETE CASCADE,
    
    -- 词汇基础信息
    word VARCHAR(100) UNIQUE NOT NULL,
    pronunciation VARCHAR(200), -- IPA音标
    pronunciation_us VARCHAR(200), -- 美式发音
    pronunciation_uk VARCHAR(200), -- 英式发音
    word_class VARCHAR(50), -- 词性
    
    -- 词汇形态
    word_forms JSONB, -- 各种词形变化
    root_word VARCHAR(100), -- 词根
    prefix VARCHAR(50), -- 前缀
    suffix VARCHAR(50), -- 后缀
    word_family TEXT[], -- 词族
    
    -- 含义信息
    definitions JSONB NOT NULL, -- 多种定义和例句
    chinese_meanings TEXT[],
    synonyms TEXT[],
    antonyms TEXT[],
    
    -- 搭配和用法
    collocations JSONB, -- 常用搭配
    phrases JSONB, -- 常用短语
    usage_notes TEXT, -- 用法说明
    
    -- 记忆辅助
    memory_tips TEXT, -- 记忆技巧
    mnemonics TEXT, -- 助记符
    etymology TEXT, -- 词源
    
    -- 频率和重要性
    frequency_rank INTEGER,
    cefr_level VARCHAR(2), -- A1, A2, B1, B2, C1, C2
    exam_frequency JSONB, -- 在各类考试中的出现频率
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 必会短文详细表
CREATE TABLE essential_passages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES essential_contents(id) ON DELETE CASCADE,
    
    -- 短文信息
    passage_type VARCHAR(50), -- reading, listening, cloze, etc.
    word_count INTEGER,
    reading_time_estimate INTEGER, -- 预估阅读时间(秒)
    
    -- 内容分析
    key_vocabulary TEXT[], -- 重点词汇
    key_phrases TEXT[], -- 重点短语
    grammar_points TEXT[], -- 涉及语法点
    topic_keywords TEXT[], -- 话题关键词
    
    -- 题目和练习
    comprehension_questions JSONB, -- 理解题目
    vocabulary_exercises JSONB, -- 词汇练习
    
    -- 音频信息（听力短文）
    audio_duration INTEGER, -- 音频时长(秒)
    speaker_accent VARCHAR(20), -- 口音类型
    speaking_speed VARCHAR(20), -- 语速：slow, normal, fast
    
    -- 分析数据
    readability_score DECIMAL(4,2), -- 可读性评分
    complexity_analysis JSONB, -- 复杂性分析
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 必会对话详细表
CREATE TABLE essential_dialogues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES essential_contents(id) ON DELETE CASCADE,
    
    -- 对话信息
    scenario VARCHAR(100) NOT NULL, -- 对话场景
    participant_count INTEGER DEFAULT 2,
    dialogue_turns INTEGER, -- 对话轮次
    total_duration INTEGER, -- 总时长(秒)
    
    -- 对话结构
    dialogue_structure JSONB NOT NULL, -- 对话内容结构
    role_descriptions JSONB, -- 角色描述
    
    -- 语言特点
    register VARCHAR(50), -- 正式程度：formal, informal, casual
    function_focus TEXT[], -- 功能重点：greeting, requesting, etc.
    cultural_notes TEXT, -- 文化注释
    
    -- 练习设置
    practice_modes TEXT[], -- 练习模式：role_play, shadowing, etc.
    ai_conversation_enabled BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 2. 用户必会学习进度表
-- ================================================================

-- 用户必会总体进度
CREATE TABLE user_essential_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID REFERENCES essential_categories(id) ON DELETE CASCADE,
    
    -- 总体进度
    total_items INTEGER DEFAULT 0,
    completed_items INTEGER DEFAULT 0,
    mastered_items INTEGER DEFAULT 0,
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- 分类进度
    vocabulary_progress JSONB, -- 词汇进度详情
    passages_progress JSONB, -- 短文进度详情
    dialogues_progress JSONB, -- 对话进度详情
    
    -- 学习统计
    total_study_time INTEGER DEFAULT 0, -- 总学习时间(秒)
    current_streak_days INTEGER DEFAULT 0,
    longest_streak_days INTEGER DEFAULT 0,
    
    -- 目标设置
    daily_target INTEGER DEFAULT 50, -- 每日学习目标
    target_completion_date DATE,
    
    -- 时间记录
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_studied_at TIMESTAMP,
    estimated_completion_date DATE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, category_id)
);

-- 用户具体内容学习记录
CREATE TABLE user_content_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    content_id UUID REFERENCES essential_contents(id) ON DELETE CASCADE,
    
    -- 掌握状态
    mastery_level mastery_level DEFAULT 'unknown',
    confidence_score INTEGER DEFAULT 0, -- 1-5，用户自评信心度
    actual_difficulty INTEGER DEFAULT 0, -- 1-5，用户感知实际难度
    
    -- 学习记录
    first_studied_at TIMESTAMP,
    last_studied_at TIMESTAMP,
    study_count INTEGER DEFAULT 0,
    total_study_time INTEGER DEFAULT 0, -- 秒
    
    -- 复习安排
    next_review_date TIMESTAMP,
    review_interval_hours INTEGER DEFAULT 24,
    consecutive_correct_count INTEGER DEFAULT 0,
    consecutive_wrong_count INTEGER DEFAULT 0,
    
    -- 错误记录
    mistake_log JSONB, -- 错误记录详情
    common_errors TEXT[], -- 常见错误类型
    
    -- 个性化数据
    learning_notes TEXT, -- 用户学习笔记
    bookmarked BOOLEAN DEFAULT false,
    difficulty_rating INTEGER, -- 用户评价的难度
    
    -- AI分析
    ai_suggested_review_time TIMESTAMP, -- AI建议复习时间
    ai_difficulty_adjustment DECIMAL(3,2), -- AI调整的个性化难度
    ai_learning_pattern JSONB, -- AI分析的学习模式
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, content_id)
);

-- ================================================================
-- 3. AI相关表
-- ================================================================

-- AI对话会话表（增强版）
CREATE TABLE ai_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 对话配置
    conversation_type VARCHAR(50), -- essential_practice, free_chat, assessment
    essential_category essential_category, -- 关联的必会分类
    target_content_ids UUID[], -- 目标练习内容ID
    
    -- AI配置
    ai_model VARCHAR(50) DEFAULT 'gpt-4',
    ai_personality VARCHAR(50) DEFAULT 'friendly_teacher',
    system_prompt TEXT,
    
    -- 对话目标
    learning_objectives TEXT[],
    target_vocabulary TEXT[],
    target_grammar_points TEXT[],
    
    -- 对话状态
    status VARCHAR(20) DEFAULT 'active', -- active, completed, paused
    turn_count INTEGER DEFAULT 0,
    
    -- 时间信息
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    total_duration INTEGER, -- 秒
    
    -- 评估结果
    overall_score INTEGER, -- 1-100
    language_accuracy INTEGER, -- 语言准确性
    vocabulary_usage INTEGER, -- 词汇使用
    fluency_score INTEGER, -- 流利度
    
    -- 反馈和建议
    ai_feedback TEXT,
    improvement_suggestions TEXT[],
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI对话消息表（增强版）
CREATE TABLE ai_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID REFERENCES ai_conversations(id) ON DELETE CASCADE,
    
    -- 消息基础信息
    sender_type VARCHAR(10) NOT NULL, -- user, ai
    message_order INTEGER NOT NULL,
    message_text TEXT,
    
    -- 音频消息
    audio_url TEXT,
    audio_duration DECIMAL(5,2),
    transcription TEXT,
    transcription_confidence DECIMAL(3,2),
    
    -- 语言分析（用户消息）
    grammar_analysis JSONB, -- 语法分析结果
    vocabulary_analysis JSONB, -- 词汇使用分析
    pronunciation_analysis JSONB, -- 发音分析
    
    -- AI响应分析（AI消息）
    ai_intent VARCHAR(100), -- AI回复意图
    teaching_points TEXT[], -- 教学要点
    corrections_made JSONB, -- 进行的纠正
    
    -- 必会内容相关
    essential_words_used TEXT[], -- 使用的必会词汇
    essential_patterns_used TEXT[], -- 使用的必会句型
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI评分记录表
CREATE TABLE ai_assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    content_id UUID REFERENCES essential_contents(id), -- 可选，关联的必会内容
    
    -- 评估类型
    assessment_type VARCHAR(50) NOT NULL, -- speech, writing, conversation
    assessment_context JSONB, -- 评估上下文信息
    
    -- 输入数据
    input_data JSONB, -- 音频、文本等输入数据的元信息
    target_content TEXT, -- 目标内容（如朗读文本）
    
    -- 评分结果
    overall_score INTEGER, -- 总分 1-100
    detailed_scores JSONB, -- 详细评分
    
    -- 反馈信息
    strengths TEXT[], -- 优点
    weaknesses TEXT[], -- 需改进点
    specific_feedback JSONB, -- 具体反馈
    improvement_suggestions TEXT[], -- 改进建议
    
    -- AI处理信息
    ai_model VARCHAR(50),
    processing_time INTEGER, -- 处理时间(毫秒)
    confidence_score DECIMAL(3,2), -- AI评分信心度
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI个性化推荐表
CREATE TABLE ai_recommendations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 推荐类型
    recommendation_type VARCHAR(50) NOT NULL, -- daily_plan, review_schedule, content_suggestion
    recommendation_context JSONB, -- 推荐上下文
    
    -- 推荐内容
    recommended_items JSONB NOT NULL, -- 推荐的具体内容
    reasoning JSONB, -- AI推荐理由
    priority_score INTEGER, -- 优先级评分 1-100
    
    -- 状态跟踪
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, declined, completed
    user_feedback INTEGER, -- 用户反馈评分 1-5
    
    -- 时效性
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP,
    
    -- AI模型信息
    ai_model VARCHAR(50),
    model_version VARCHAR(20),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 4. 学习数据分析表
-- ================================================================

-- 用户学习行为日志（增强版）
CREATE TABLE learning_behavior_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 行为基础信息
    behavior_type VARCHAR(50) NOT NULL, -- study, review, test, ai_chat, etc.
    behavior_context JSONB, -- 行为上下文
    
    -- 关联内容
    essential_category essential_category,
    content_id UUID REFERENCES essential_contents(id),
    
    -- 行为数据
    duration_seconds INTEGER,
    result_data JSONB, -- 结果数据
    performance_metrics JSONB, -- 性能指标
    
    -- 环境信息
    device_info JSONB,
    network_quality VARCHAR(20), -- wifi, 4g, 3g, poor
    time_of_day INTEGER, -- 0-23
    day_of_week INTEGER, -- 1-7
    
    -- AI增强分析
    ai_insights JSONB, -- AI生成的学习行为洞察
    learning_efficiency DECIMAL(3,2), -- 学习效率评分
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 学习效果统计表
CREATE TABLE learning_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- 时间范围
    period_type VARCHAR(20) NOT NULL, -- daily, weekly, monthly
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    
    -- 学习量统计
    total_study_time INTEGER DEFAULT 0, -- 秒
    total_items_studied INTEGER DEFAULT 0,
    total_items_mastered INTEGER DEFAULT 0,
    
    -- 各类型内容统计
    vocabulary_stats JSONB,
    passages_stats JSONB,
    dialogues_stats JSONB,
    ai_interaction_stats JSONB,
    
    -- 性能指标
    average_accuracy DECIMAL(5,2),
    learning_velocity DECIMAL(5,2), -- 学习速度
    retention_rate DECIMAL(5,2), -- 保持率
    
    -- AI分析结果
    ai_performance_analysis JSONB, -- AI性能分析
    ai_recommendation_summary JSONB, -- AI推荐总结
    predicted_outcomes JSONB, -- 预测结果
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, period_type, period_start)
);

-- ================================================================
-- 5. 创建索引
-- ================================================================

-- 必会内容相关索引
CREATE INDEX idx_essential_categories_key ON essential_categories(category_key);
CREATE INDEX idx_essential_categories_active ON essential_categories(is_active, sort_order);

CREATE INDEX idx_essential_contents_category ON essential_contents(category_id);
CREATE INDEX idx_essential_contents_type ON essential_contents(content_type);
CREATE INDEX idx_essential_contents_difficulty ON essential_contents(difficulty_level);
CREATE INDEX idx_essential_contents_published ON essential_contents(is_published, created_at DESC);
CREATE INDEX idx_essential_contents_importance ON essential_contents(importance_score DESC);
CREATE INDEX idx_essential_contents_embedding ON essential_contents USING hnsw (ai_embedding vector_cosine_ops);

CREATE INDEX idx_essential_vocabulary_word ON essential_vocabulary(word);
CREATE INDEX idx_essential_vocabulary_frequency ON essential_vocabulary(frequency_rank);
CREATE INDEX idx_essential_vocabulary_cefr ON essential_vocabulary(cefr_level);

-- 用户进度相关索引
CREATE INDEX idx_user_essential_progress_user ON user_essential_progress(user_id);
CREATE INDEX idx_user_essential_progress_category ON user_essential_progress(category_id);
CREATE INDEX idx_user_essential_progress_completion ON user_essential_progress(completion_percentage DESC);

CREATE INDEX idx_user_content_progress_user ON user_content_progress(user_id);
CREATE INDEX idx_user_content_progress_content ON user_content_progress(content_id);
CREATE INDEX idx_user_content_progress_mastery ON user_content_progress(mastery_level);
CREATE INDEX idx_user_content_progress_review ON user_content_progress(next_review_date) WHERE next_review_date IS NOT NULL;

-- AI相关索引
CREATE INDEX idx_ai_conversations_user ON ai_conversations(user_id, started_at DESC);
CREATE INDEX idx_ai_conversations_category ON ai_conversations(essential_category, started_at DESC);
CREATE INDEX idx_ai_messages_conversation ON ai_messages(conversation_id, message_order);
CREATE INDEX idx_ai_assessments_user ON ai_assessments(user_id, created_at DESC);
CREATE INDEX idx_ai_assessments_type ON ai_assessments(assessment_type, created_at DESC);
CREATE INDEX idx_ai_recommendations_user ON ai_recommendations(user_id, status);

-- 行为分析相关索引
CREATE INDEX idx_learning_behavior_user_time ON learning_behavior_logs(user_id, created_at DESC);
CREATE INDEX idx_learning_behavior_type ON learning_behavior_logs(behavior_type, created_at DESC);
CREATE INDEX idx_learning_behavior_category ON learning_behavior_logs(essential_category, created_at DESC);
CREATE INDEX idx_learning_analytics_user_period ON learning_analytics(user_id, period_type, period_start DESC);

-- ================================================================
-- 6. 创建视图
-- ================================================================

-- 必会学习概览视图
CREATE VIEW essential_learning_overview AS
SELECT 
    u.id as user_id,
    u.username,
    ec.category_key,
    ec.name as category_name,
    uep.completion_percentage,
    uep.completed_items,
    uep.total_items,
    uep.current_streak_days,
    uep.total_study_time,
    uep.last_studied_at,
    CASE 
        WHEN uep.last_studied_at > CURRENT_DATE - INTERVAL '1 day' THEN 'active'
        WHEN uep.last_studied_at > CURRENT_DATE - INTERVAL '7 days' THEN 'inactive'
        ELSE 'dormant'
    END as learning_status
FROM users u
LEFT JOIN user_essential_progress uep ON u.id = uep.user_id
LEFT JOIN essential_categories ec ON uep.category_id = ec.id
WHERE uep.total_items > 0;

-- AI交互统计视图
CREATE VIEW ai_interaction_stats AS
SELECT 
    user_id,
    COUNT(DISTINCT conversation_id) as total_conversations,
    AVG(overall_score) as average_conversation_score,
    SUM(turn_count) as total_turns,
    SUM(total_duration) as total_ai_time,
    COUNT(DISTINCT DATE(started_at)) as active_ai_days,
    MAX(started_at) as last_ai_interaction
FROM ai_conversations
WHERE status = 'completed'
GROUP BY user_id;

-- 内容难度分析视图
CREATE VIEW content_difficulty_analysis AS
SELECT 
    ec.content_id,
    ec.content_type,
    ec.difficulty_level as system_difficulty,
    AVG(ucp.actual_difficulty) as user_perceived_difficulty,
    AVG(ucp.confidence_score) as average_confidence,
    COUNT(ucp.user_id) as learner_count,
    AVG(ucp.total_study_time) as average_study_time,
    COUNT(CASE WHEN ucp.mastery_level IN ('mastered', 'expert') THEN 1 END) as mastered_count
FROM essential_contents ec
LEFT JOIN user_content_progress ucp ON ec.id = ucp.content_id
GROUP BY ec.content_id, ec.content_type, ec.difficulty_level;

-- ================================================================
-- 7. 创建触发器和函数
-- ================================================================

-- 更新用户总体进度的函数
CREATE OR REPLACE FUNCTION update_essential_progress()
RETURNS TRIGGER AS $$
BEGIN
    -- 更新用户在该分类下的总体进度
    UPDATE user_essential_progress 
    SET 
        completed_items = (
            SELECT COUNT(*) FROM user_content_progress ucp
            JOIN essential_contents ec ON ucp.content_id = ec.id
            WHERE ucp.user_id = NEW.user_id 
            AND ec.category_id = (
                SELECT category_id FROM essential_contents WHERE id = NEW.content_id
            )
            AND ucp.mastery_level IN ('familiar', 'mastered', 'expert')
        ),
        mastered_items = (
            SELECT COUNT(*) FROM user_content_progress ucp
            JOIN essential_contents ec ON ucp.content_id = ec.id
            WHERE ucp.user_id = NEW.user_id 
            AND ec.category_id = (
                SELECT category_id FROM essential_contents WHERE id = NEW.content_id
            )
            AND ucp.mastery_level IN ('mastered', 'expert')
        ),
        completion_percentage = (
            SELECT ROUND(
                (COUNT(CASE WHEN ucp.mastery_level IN ('familiar', 'mastered', 'expert') THEN 1 END) * 100.0 / COUNT(*))::numeric, 2
            )
            FROM user_content_progress ucp
            JOIN essential_contents ec ON ucp.content_id = ec.id
            WHERE ucp.user_id = NEW.user_id 
            AND ec.category_id = (
                SELECT category_id FROM essential_contents WHERE id = NEW.content_id
            )
        ),
        last_studied_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE user_id = NEW.user_id 
    AND category_id = (
        SELECT category_id FROM essential_contents WHERE id = NEW.content_id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER update_essential_progress_trigger
    AFTER INSERT OR UPDATE ON user_content_progress
    FOR EACH ROW EXECUTE FUNCTION update_essential_progress();

-- AI向量搜索函数
CREATE OR REPLACE FUNCTION find_similar_content(
    query_embedding VECTOR(1536),
    content_type essential_content_type DEFAULT NULL,
    limit_count INTEGER DEFAULT 10
)
RETURNS TABLE(
    content_id UUID,
    title VARCHAR(255),
    similarity_score DECIMAL(5,4)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ec.id,
        ec.title,
        (1 - (ec.ai_embedding <=> query_embedding))::DECIMAL(5,4) as similarity_score
    FROM essential_contents ec
    WHERE 
        ec.is_published = true
        AND (content_type IS NULL OR ec.content_type = find_similar_content.content_type)
    ORDER BY ec.ai_embedding <=> query_embedding
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- 8. 初始化数据
-- ================================================================

-- 插入必会分类数据
INSERT INTO essential_categories (
    category_key, name, display_name_cn, display_name_en, 
    target_level, age_group, difficulty_color, 
    total_vocabulary_count, total_passages_count, total_dialogues_count,
    estimated_duration_days, is_popular
) VALUES 
(
    'junior_high', 'junior_high_essentials', '初中必会', 'Junior High Essentials',
    'A1-A2', '13-16', '#4CAF50',
    1500, 50, 30, 90, false
),
(
    'senior_high', 'senior_high_essentials', '高中必会', 'Senior High Essentials', 
    'A2-B1', '16-18', '#FF9800',
    3500, 100, 50, 120, false
),
(
    'cet4', 'cet4_essentials', '四级必会', 'CET-4 Essentials',
    'B1', '18-25', '#2196F3', 
    4500, 100, 100, 100, true
),
(
    'cet6', 'cet6_essentials', '六级必会', 'CET-6 Essentials',
    'B2', '18-25', '#9C27B0',
    6000, 150, 120, 120, true
),
(
    'postgraduate', 'postgraduate_essentials', '考研必会', 'Postgraduate Essentials',
    'B2-C1', '22-28', '#F44336',
    5500, 200, 80, 150, true
),
(
    'daily_life', 'daily_life_essentials', '日常必会', 'Daily Life Essentials',
    'A2-B2', '16-60', '#607D8B',
    3000, 80, 100, 90, false
),
(
    'business', 'business_essentials', '商务必会', 'Business Essentials',
    'B1-B2', '22-45', '#795548', 
    2500, 60, 80, 80, false
);

-- 插入应用配置
INSERT INTO app_configs (config_key, config_value, description, is_public) VALUES
('ai_models_available', '["gpt-4", "gpt-3.5-turbo"]', '可用的AI模型列表', false),
('ai_conversation_max_turns', '50', 'AI对话最大轮次', false),
('essential_daily_target_default', '50', '必会内容默认每日目标', true),
('ai_assessment_enabled', 'true', 'AI评估功能开关', true),
('vector_search_enabled', 'true', '向量搜索功能开关', false),
('learning_analytics_retention_days', '365', '学习分析数据保留天数', false);

-- ================================================================
-- 9. 性能优化建议
-- ================================================================

-- 1. 分区建议
-- 可考虑按时间对learning_behavior_logs表分区
-- CREATE TABLE learning_behavior_logs_y2024m08 PARTITION OF learning_behavior_logs
-- FOR VALUES FROM ('2024-08-01') TO ('2024-09-01');

-- 2. 定期维护任务
-- 清理过期的AI推荐: DELETE FROM ai_recommendations WHERE valid_until < CURRENT_TIMESTAMP;
-- 清理旧的行为日志: DELETE FROM learning_behavior_logs WHERE created_at < CURRENT_DATE - INTERVAL '90 days';
-- 更新内容统计: 定期更新essential_contents表中的统计数据

-- 3. 向量索引优化
-- 定期重建向量索引以提高搜索性能: REINDEX INDEX idx_essential_contents_embedding;

-- 结束脚本
-- 数据库架构版本: 2.0
-- 支持功能: 必会专题学习 + AI智能功能
-- 最后更新: 2024年8月6日