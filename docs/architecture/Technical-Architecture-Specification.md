# ChatLingo 技术架构规格文档

## 1. 总体架构

### 1.1 架构概览
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   iOS Client    │────│   API Gateway   │────│  Microservices  │
│                 │    │                 │    │                 │
│ SwiftUI + UIKit │    │   Node.js +     │    │ - Auth Service  │
│                 │    │   Express       │    │ - Learn Service │
└─────────────────┘    └─────────────────┘    │ - Chat Service  │
         │                        │            │ - User Service  │
         │                        │            └─────────────────┘
         │                        │                      │
         │                        │                      │
    ┌────▼────┐              ┌────▼────┐           ┌────▼────┐
    │ Core ML │              │  Redis  │           │PostgreSQL│
    │  Local  │              │  Cache  │           │Database │
    │ Storage │              └─────────┘           └─────────┘
    └─────────┘
```

### 1.2 架构原则
- **微服务架构**: 业务模块独立部署，便于扩展和维护
- **前后端分离**: iOS客户端与后端API完全解耦
- **缓存优先**: 多层缓存策略，提升响应速度
- **安全至上**: 端到端加密，数据安全防护
- **可扩展性**: 水平扩展支持，应对用户增长

## 2. 前端架构 (iOS)

### 2.1 技术栈
```swift
// 核心框架
- iOS 15.0+
- Swift 5.7+
- SwiftUI 4.0
- UIKit (复杂交互)
- Combine (响应式编程)

// 数据层
- Core Data (本地存储)
- CloudKit (云端同步)
- Keychain (安全存储)

// 网络层
- URLSession
- Alamofire 5.0

// 音频视频
- AVFoundation
- Core Audio
- Speech Framework

// AI/ML
- Core ML
- Natural Language
- Vision (图像识别)

// 其他
- ARKit (AR功能)
- StoreKit (内购)
- UserNotifications
```

### 2.2 应用架构模式

#### 2.2.1 MVVM + Coordinator 模式
```swift
// 视图模型示例
class LearningViewModel: ObservableObject {
    @Published var currentLesson: Lesson?
    @Published var progress: Double = 0.0
    @Published var isLoading: Bool = false
    
    private let learningService: LearningServiceProtocol
    private let coordinator: MainCoordinator
    
    func startLesson(_ lesson: Lesson) {
        isLoading = true
        learningService.startLesson(lesson) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let lessonData):
                    self?.currentLesson = lessonData
                case .failure(let error):
                    self?.coordinator.showError(error)
                }
            }
        }
    }
}
```

#### 2.2.2 网络层架构
```swift
// 网络服务协议
protocol NetworkServiceProtocol {
    func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T
}

// API端点枚举
enum APIEndpoint {
    case login(credentials: LoginCredentials)
    case getLessons(level: String)
    case submitProgress(progress: LearningProgress)
    case chatWithAI(message: String)
    
    var url: URL { /* 实现 */ }
    var method: HTTPMethod { /* 实现 */ }
    var headers: [String: String] { /* 实现 */ }
}
```

### 2.3 数据管理

#### 2.3.1 Core Data模型
```swift
// 用户实体
@objc(User)
public class User: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var username: String
    @NSManaged public var email: String
    @NSManaged public var level: String
    @NSManaged public var createdAt: Date
    @NSManaged public var learningProgress: NSSet?
}

// 课程实体
@objc(Lesson)
public class Lesson: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var content: Data // JSON content
    @NSManaged public var difficulty: String
    @NSManaged public var type: String
    @NSManaged public var isCompleted: Bool
}
```

#### 2.3.2 本地缓存策略
```swift
class CacheManager {
    static let shared = CacheManager()
    
    private let cache = NSCache<NSString, AnyObject>()
    private let fileManager = FileManager.default
    
    func cacheLesson(_ lesson: Lesson, forKey key: String) {
        // 内存缓存
        cache.setObject(lesson, forKey: NSString(string: key))
        
        // 磁盘缓存
        let cacheURL = getCacheURL(for: key)
        try? lesson.data.write(to: cacheURL)
    }
}
```

## 3. 后端架构

### 3.1 微服务架构

#### 3.1.1 服务划分
```javascript
// 认证服务 (Auth Service)
const authService = {
    port: 3001,
    responsibilities: [
        'User registration/login',
        'JWT token management',
        'OAuth integration',
        'Password reset'
    ]
}

// 学习服务 (Learning Service)
const learningService = {
    port: 3002,
    responsibilities: [
        'Lesson management',
        'Progress tracking',
        'Learning analytics',
        'Recommendation engine'
    ]
}

// 对话服务 (Chat Service)
const chatService = {
    port: 3003,
    responsibilities: [
        'AI conversation',
        'Speech recognition',
        'Grammar correction',
        'Conversation history'
    ]
}
```

#### 3.1.2 API Gateway
```javascript
// API网关配置
const gatewayConfig = {
    routes: [
        {
            path: '/api/auth/*',
            target: 'http://auth-service:3001',
            middleware: ['rateLimiting', 'logging']
        },
        {
            path: '/api/learning/*',
            target: 'http://learning-service:3002',
            middleware: ['authentication', 'rateLimiting']
        },
        {
            path: '/api/chat/*',
            target: 'http://chat-service:3003',
            middleware: ['authentication', 'rateLimiting', 'aiThrottling']
        }
    ]
}
```

### 3.2 数据库设计

#### 3.2.1 主数据库 (PostgreSQL)
```sql
-- 用户表
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    english_level VARCHAR(10) DEFAULT 'A1',
    subscription_type VARCHAR(20) DEFAULT 'free',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 课程表
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    content JSONB NOT NULL,
    difficulty VARCHAR(10) NOT NULL,
    type VARCHAR(50) NOT NULL,
    tags TEXT[] DEFAULT '{}',
    estimated_duration INTEGER, -- minutes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 学习进度表
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    lesson_id UUID REFERENCES lessons(id),
    progress_percentage INTEGER DEFAULT 0,
    completed_at TIMESTAMP,
    score INTEGER,
    time_spent INTEGER, -- seconds
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 对话记录表
CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    session_type VARCHAR(50) NOT NULL,
    messages JSONB NOT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP
);
```

#### 3.2.2 缓存策略 (Redis)
```javascript
// Redis缓存键设计
const cacheKeys = {
    user: (userId) => `user:${userId}`,
    userProgress: (userId) => `progress:${userId}`,
    lessons: (level) => `lessons:${level}`,
    chatSession: (sessionId) => `chat:${sessionId}`,
    recommendations: (userId) => `rec:${userId}`
}

// 缓存TTL设置
const cacheTTL = {
    user: 3600,      // 1小时
    lessons: 7200,   // 2小时
    progress: 1800,  // 30分钟
    chat: 86400      // 24小时
}
```

### 3.3 AI服务集成

#### 3.3.1 ChatGPT集成
```javascript
class ChatGPTService {
    constructor() {
        this.client = new OpenAI({
            apiKey: process.env.OPENAI_API_KEY
        });
    }
    
    async generateResponse(userMessage, context) {
        const messages = [
            {
                role: "system",
                content: `You are an English learning assistant. 
                         Help the user practice English conversation.
                         Current user level: ${context.userLevel}
                         Learning topic: ${context.topic}`
            },
            {
                role: "user",
                content: userMessage
            }
        ];
        
        const response = await this.client.chat.completions.create({
            model: "gpt-4",
            messages: messages,
            max_tokens: 200,
            temperature: 0.7
        });
        
        return response.choices[0].message.content;
    }
}
```

#### 3.3.2 语音识别服务
```javascript
class SpeechService {
    constructor() {
        this.azureKey = process.env.AZURE_SPEECH_KEY;
        this.azureRegion = process.env.AZURE_SPEECH_REGION;
    }
    
    async recognizeSpeech(audioBuffer) {
        const config = SpeechConfig.fromSubscription(
            this.azureKey, 
            this.azureRegion
        );
        
        const audioConfig = AudioConfig.fromWavFileInput(audioBuffer);
        const recognizer = new SpeechRecognizer(config, audioConfig);
        
        return new Promise((resolve, reject) => {
            recognizer.recognizeOnceAsync(result => {
                if (result.reason === ResultReason.RecognizedSpeech) {
                    resolve({
                        text: result.text,
                        confidence: result.properties.getProperty(
                            PropertyId.SpeechServiceResponse_JsonResult
                        )
                    });
                } else {
                    reject(new Error('Speech recognition failed'));
                }
            });
        });
    }
}
```

## 4. 部署架构

### 4.1 容器化部署
```dockerfile
# Node.js服务Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
```

### 4.2 Kubernetes配置
```yaml
# learning-service部署配置
apiVersion: apps/v1
kind: Deployment
metadata:
  name: learning-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: learning-service
  template:
    metadata:
      labels:
        app: learning-service
    spec:
      containers:
      - name: learning-service
        image: chatlingo/learning-service:latest
        ports:
        - containerPort: 3002
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: redis-secret
              key: url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

### 4.3 监控和日志
```javascript
// 应用监控中间件
const monitoring = require('./monitoring');

app.use(monitoring.requestLogger);
app.use(monitoring.errorTracker);
app.use(monitoring.performanceMetrics);

// 健康检查端点
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        version: process.env.APP_VERSION
    });
});
```

## 5. 安全架构

### 5.1 身份认证与授权
```javascript
// JWT配置
const jwtConfig = {
    secret: process.env.JWT_SECRET,
    expiresIn: '24h',
    algorithm: 'HS256'
};

// 权限中间件
const authorize = (roles) => {
    return (req, res, next) => {
        const token = req.headers.authorization?.split(' ')[1];
        
        if (!token) {
            return res.status(401).json({ error: 'No token provided' });
        }
        
        try {
            const decoded = jwt.verify(token, jwtConfig.secret);
            
            if (roles && !roles.includes(decoded.role)) {
                return res.status(403).json({ error: 'Insufficient permissions' });
            }
            
            req.user = decoded;
            next();
        } catch (error) {
            return res.status(401).json({ error: 'Invalid token' });
        }
    };
};
```

### 5.2 数据加密
```swift
// iOS端数据加密
class EncryptionManager {
    private let keychain = KeychainSwift()
    
    func encryptSensitiveData(_ data: Data) -> Data? {
        guard let key = getOrCreateEncryptionKey() else { return nil }
        
        let aes = AES(key: key.bytes, blockMode: CBC(iv: randomIV), padding: .pkcs7)
        return try? Data(aes.encrypt(data.bytes))
    }
    
    private func getOrCreateEncryptionKey() -> Data? {
        if let existingKey = keychain.getData("encryption_key") {
            return existingKey
        }
        
        let newKey = Data.randomKey(length: 32)
        keychain.set(newKey, forKey: "encryption_key")
        return newKey
    }
}
```

## 6. 性能优化

### 6.1 前端优化
```swift
// 图片缓存和懒加载
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL) -> AsyncImage<Image, Never> {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
    }
}

// 内存管理
class MemoryManager {
    func optimizeMemoryUsage() {
        // 清理未使用的缓存
        URLCache.shared.removeAllCachedResponses()
        
        // 限制并发网络请求
        URLSession.shared.configuration.httpMaximumConnectionsPerHost = 4
    }
}
```

### 6.2 后端优化
```javascript
// 数据库查询优化
class QueryOptimizer {
    // 使用连接池
    static createConnectionPool() {
        return new Pool({
            connectionString: process.env.DATABASE_URL,
            max: 20,
            idleTimeoutMillis: 30000,
            connectionTimeoutMillis: 2000,
        });
    }
    
    // 分页查询
    static async getPaginatedLessons(page, limit, level) {
        const offset = (page - 1) * limit;
        
        const query = `
            SELECT * FROM lessons 
            WHERE difficulty = $1 
            ORDER BY created_at DESC 
            LIMIT $2 OFFSET $3
        `;
        
        return await pool.query(query, [level, limit, offset]);
    }
}

// Redis缓存优化
class CacheOptimizer {
    static async getOrSet(key, fetcher, ttl = 3600) {
        let cached = await redis.get(key);
        
        if (cached) {
            return JSON.parse(cached);
        }
        
        const data = await fetcher();
        await redis.setex(key, ttl, JSON.stringify(data));
        
        return data;
    }
}
```

## 7. 测试策略

### 7.1 前端测试
```swift
// 单元测试示例
class LearningViewModelTests: XCTestCase {
    var viewModel: LearningViewModel!
    var mockService: MockLearningService!
    
    override func setUp() {
        super.setUp()
        mockService = MockLearningService()
        viewModel = LearningViewModel(service: mockService)
    }
    
    func testStartLesson() {
        // Given
        let lesson = Lesson(id: UUID(), title: "Test Lesson")
        mockService.shouldSucceed = true
        
        // When
        viewModel.startLesson(lesson)
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        
        // Wait for async completion
        let expectation = expectation(description: "Lesson loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.currentLesson?.id, lesson.id)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}
```

### 7.2 后端测试
```javascript
// API测试示例
describe('Learning API', () => {
    beforeEach(async () => {
        await database.clean();
        await database.seed();
    });
    
    describe('GET /api/learning/lessons', () => {
        it('should return lessons for user level', async () => {
            const response = await request(app)
                .get('/api/learning/lessons?level=A1')
                .set('Authorization', `Bearer ${validToken}`)
                .expect(200);
            
            expect(response.body.lessons).toHaveLength(5);
            expect(response.body.lessons[0]).toHaveProperty('title');
            expect(response.body.lessons[0]).toHaveProperty('difficulty', 'A1');
        });
    });
});
```

---

**文档版本**: v1.0  
**最后更新**: 2024年8月6日  
**审核人**: 技术架构师