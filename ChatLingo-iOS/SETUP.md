# ChatLingo iOS 项目设置指南

## 快速开始

我已经为你创建了一个完整的iOS项目结构，包含了所有必要的文件和配置。以下是如何在Xcode中打开和运行项目的步骤：

## 1. 在Xcode中打开项目

有两种方式打开项目：

### 方式一：直接双击项目文件
```bash
open ChatLingo.xcodeproj
```

### 方式二：在Xcode中打开
1. 打开Xcode
2. 选择 "Open a project or file"
3. 导航到 `ChatLingo-iOS` 文件夹
4. 选择 `ChatLingo.xcodeproj` 文件

## 2. 项目配置

### 基本信息
- **Bundle Identifier**: `com.chatlingo.ios`
- **Deployment Target**: iOS 15.0+
- **Swift Version**: 5.7+
- **Architecture**: MVVM + Coordinator

### 依赖管理
项目同时支持 Swift Package Manager 和 CocoaPods：

#### 使用 Swift Package Manager (推荐)
- 依赖已在 `Package.swift` 中定义
- Xcode会自动解析和下载依赖
- 无需额外配置

#### 使用 CocoaPods
如果你更喜欢使用CocoaPods：
```bash
cd ChatLingo-iOS
pod install
open ChatLingo.xcworkspace  # 注意是.xcworkspace文件
```

## 3. 运行项目

1. **选择模拟器**: 在Xcode顶部选择iPhone 15或其他iOS 15.0+模拟器
2. **构建并运行**: 按 `Cmd + R` 或点击播放按钮
3. **首次运行**: 可能需要几分钟来下载和编译依赖

## 4. 项目结构说明

```
ChatLingo/
├── App/                    # 应用程序入口
│   ├── ChatLingoApp.swift  # @main应用入口
│   ├── ContentView.swift   # 主内容视图
│   └── Info.plist         # 应用配置
├── Core/                  # 核心架构
│   ├── Models/            # 数据模型
│   ├── Views/             # 共享视图组件
│   ├── Coordinators/      # 导航协调器
│   └── ...
├── Features/              # 功能模块
│   ├── Essential/         # 必会专题功能
│   ├── AI/               # AI助手功能
│   ├── Learning/         # 学习进度
│   └── Profile/          # 用户档案
└── Resources/            # 资源文件
    └── Colors/           # 颜色系统
```

## 5. 开发环境要求

- **macOS**: 13.0+ (Ventura)
- **Xcode**: 15.0+
- **iOS Deployment Target**: 15.0+
- **Swift**: 5.7+

## 6. 核心功能模块

### 已实现的功能
✅ 基础项目结构和导航  
✅ 必会专题数据模型  
✅ AI功能数据模型  
✅ 主标签页导航  
✅ 必会专题首页UI  
✅ 颜色系统和设计规范  

### 待实现的功能
⏳ 完整的必会专题学习流程  
⏳ AI对话功能集成  
⏳ 语音识别和评分  
⏳ 用户数据持久化  
⏳ 网络API集成  

## 7. API密钥配置

在开始AI功能开发前，需要配置API密钥：

1. **创建配置文件**:
```bash
mkdir ChatLingo/Config
touch ChatLingo/Config/APIKeys.swift
```

2. **添加API密钥** (添加到 `APIKeys.swift`):
```swift
struct APIKeys {
    static let openAI = "your-openai-api-key"
    static let azureSpeech = "your-azure-speech-key"
    static let backendBaseURL = "your-backend-url"
}
```

3. **在 `.gitignore` 中已经排除了 `Config/` 文件夹**，确保API密钥不会被提交到版本控制。

## 8. 开发工作流

### 代码规范
- 项目已配置 SwiftLint，会自动检查代码风格
- 运行 `swiftlint` 命令检查代码规范
- 使用 `swiftlint autocorrect` 自动修复问题

### 测试
- **单元测试**: `ChatLingoTests` 文件夹
- **UI测试**: `ChatLingoUITests` 文件夹
- 运行测试: `Cmd + U`

### 调试
- 使用Xcode内置调试器
- 查看控制台输出
- 使用断点调试

## 9. 常见问题

### Q: 编译错误 - 找不到模块
**A**: 检查 Swift Package Manager 依赖是否正确下载：
- 在Xcode中选择 File → Swift Packages → Reset Package Caches
- 重新构建项目

### Q: 模拟器运行缓慢
**A**: 
- 选择较新的模拟器设备 (iPhone 15)
- 在模拟器中选择 Device → Erase All Content and Settings
- 重启Xcode和模拟器

### Q: 颜色无法显示
**A**: 项目使用了自定义颜色，需要在 Assets.xcassets 中添加对应的颜色资源。当前是使用代码中的占位颜色。

## 10. 下一步开发计划

1. **完善UI资源**: 添加颜色、图标和图片资源
2. **实现网络层**: 创建API服务和数据仓库
3. **集成AI功能**: OpenAI GPT-4 对话集成
4. **添加语音功能**: 录音、播放和语音识别
5. **数据持久化**: Core Data 数据库设置
6. **用户认证**: 登录注册和用户管理

## 联系方式

如果在项目设置过程中遇到问题，可以：
- 查看 Xcode 控制台的错误信息
- 检查项目的构建设置
- 确保所有依赖都正确安装

项目已经创建完成，现在可以在Xcode中打开并开始开发了！🚀