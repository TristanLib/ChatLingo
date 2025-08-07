# ChatLingo iOS App

## 项目概述

ChatLingo iOS应用是基于"必会"专题学习理念和AI智能助手技术的英语学习应用。本项目采用Swift 5.7+和SwiftUI构建，支持iOS 15.0+。

## 技术架构

### 架构模式
- **MVVM + Coordinator**: 清晰的职责分离和导航管理
- **SwiftUI + UIKit**: 现代UI框架与传统框架的最佳结合
- **Combine**: 响应式编程和数据绑定

### 核心技术栈
- **前端**: Swift 5.7+, SwiftUI, UIKit, Combine
- **网络层**: Alamofire 5.8+
- **AI集成**: OpenAI Swift SDK
- **数据存储**: Core Data + CloudKit
- **安全存储**: Keychain Swift
- **音频处理**: AVFoundation + Speech Framework
- **动画**: Lottie iOS

## 项目结构

```
ChatLingo-iOS/
├── ChatLingo/
│   ├── App/                    # 应用入口和主要配置
│   │   ├── ChatLingoApp.swift  # App主入口
│   │   ├── ContentView.swift   # 主内容视图
│   │   └── Info.plist         # 应用配置
│   ├── Core/                  # 核心框架代码
│   │   ├── Models/            # 数据模型
│   │   │   ├── EssentialModels.swift  # 必会专题模型
│   │   │   └── AIModels.swift         # AI功能模型
│   │   ├── ViewModels/        # 视图模型(MVVM)
│   │   ├── Views/             # 通用视图组件
│   │   │   └── MainTabView.swift      # 主标签页
│   │   ├── Services/          # 服务层
│   │   ├── Coordinators/      # 导航协调器
│   │   │   └── AppCoordinator.swift   # 主导航协调器
│   │   ├── Extensions/        # Swift扩展
│   │   └── Utilities/         # 工具类
│   ├── Features/              # 功能模块
│   │   ├── Essential/         # 必会专题功能
│   │   ├── AI/               # AI助手功能
│   │   ├── Profile/          # 用户档案
│   │   └── Learning/         # 学习进度
│   └── Resources/            # 资源文件
│       ├── Assets/           # 图片资源
│       ├── Colors/           # 颜色定义
│       │   └── Colors.swift   # 应用颜色系统
│       ├── Fonts/            # 字体文件
│       └── Strings/          # 本地化文字
├── ChatLingoTests/           # 单元测试
├── ChatLingoUITests/         # UI测试
├── Package.swift            # Swift Package依赖
├── Podfile                  # CocoaPods依赖
└── .swiftlint.yml          # 代码规范配置
```

## 环境要求

- **Xcode**: 15.0+
- **iOS**: 15.0+
- **Swift**: 5.7+
- **CocoaPods**: 1.12.0+

## 安装步骤

1. **克隆仓库**
```bash
git clone https://github.com/TristanLib/ChatLingo.git
cd ChatLingo/ChatLingo-iOS
```

2. **安装依赖**
```bash
# 安装CocoaPods依赖
pod install

# 或使用Swift Package Manager (推荐)
# 依赖已在Package.swift中定义，Xcode会自动处理
```

3. **在Xcode中打开项目**
```bash
open ChatLingo.xcworkspace  # 如果使用CocoaPods
# 或
open ChatLingo.xcodeproj    # 如果只使用SPM
```

4. **配置API密钥**
- 创建 `ChatLingo/Config/APIKeys.swift` 文件
- 添加OpenAI API密钥和其他必要的配置

## 开发命令

### 构建和运行
```bash
# 在Xcode中按Cmd+R运行
# 或使用xcodebuild命令行工具
xcodebuild -project ChatLingo.xcodeproj -scheme ChatLingo -destination 'platform=iOS Simulator,name=iPhone 15' build
```

### 代码格式化和检查
```bash
# 运行SwiftLint检查
swiftlint

# 自动修复可修复的问题
swiftlint autocorrect
```

### 运行测试
```bash
# 运行单元测试
xcodebuild test -project ChatLingo.xcodeproj -scheme ChatLingo -destination 'platform=iOS Simulator,name=iPhone 15'

# 在Xcode中按Cmd+U运行测试
```

## 核心功能模块

### 1. 必会专题系统 (Essential Learning)
- **分级学习内容**: 初中/高中/四六级/考研/商务等分类
- **词汇管理**: 分级词汇学习和记忆曲线
- **短文阅读**: 精选短文和理解练习
- **对话练习**: 场景化对话训练

### 2. AI智能助手 (AI Features)
- **智能对话**: GPT-4驱动的英语对话练习
- **语音评分**: 发音准确度和流利度评估
- **个性化推荐**: 基于学习数据的智能推荐
- **实时纠错**: 语法和用词即时反馈

### 3. 学习进度追踪 (Learning Progress)
- **详细统计**: 学习时长、完成率、掌握度
- **可视化图表**: 进步趋势和能力雷达图
- **成就系统**: 学习里程碑和奖励机制

### 4. 用户系统 (User Management)
- **个人档案**: 学习目标和偏好设置
- **云端同步**: 学习进度跨设备同步
- **社交功能**: 学习排行榜和好友系统

## 设计系统

### 颜色系统
- **必会专题颜色**: 每个学习阶段都有专属的颜色主题
- **掌握度颜色**: 从未学习到精通的渐进色彩
- **AI功能颜色**: AI助手不同角色的特色颜色

### 字体系统
- **中文**: PingFang SC (系统默认)
- **英文**: San Francisco (系统默认)
- **代码**: SF Mono (等宽字体)

### 图标系统
- 使用SF Symbols为主
- 自定义图标使用SVG格式
- 支持深色模式适配

## API集成

### OpenAI GPT-4
- 智能对话生成
- 语法错误检测
- 学习内容推荐

### Azure Speech Services
- 语音识别和转录
- 发音评分和反馈
- 语音合成(TTS)

### 后端API
- RESTful API设计
- JWT认证和授权
- 实时数据同步

## 测试策略

### 单元测试
- 模型层测试
- 业务逻辑测试
- 工具类测试

### UI测试
- 核心用户流程测试
- 界面交互测试
- 无障碍功能测试

### 集成测试
- API集成测试
- 数据持久化测试
- 推送通知测试

## 发布流程

1. **版本管理**: 使用语义化版本号 (Semantic Versioning)
2. **代码审查**: 所有PR都需要经过代码审查
3. **自动化测试**: CI/CD流程确保代码质量
4. **Beta测试**: TestFlight内测版本发布
5. **App Store发布**: 正式版本发布到App Store

## 贡献指南

1. Fork本项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 许可证

本项目采用MIT许可证 - 详见 [LICENSE](LICENSE) 文件

## 联系方式

- **项目负责人**: 产品规划师
- **技术支持**: tech@chatlingo.com
- **问题反馈**: [GitHub Issues](https://github.com/TristanLib/ChatLingo/issues)

---

**注意**: 这是一个正在开发中的项目，某些功能可能尚未完全实现。请参考项目路线图了解开发进度。