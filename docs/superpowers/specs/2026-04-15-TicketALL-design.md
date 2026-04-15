# TicketALL 项目设计文档

**日期**: 2026-04-15  
**版本**: v1.0

## 1. 项目概述

### 1.1 产品定位
TicketALL 是一款 iOS 移动端 App，利用 AI 技术（OCR + 背景生成）将纸质票据、电子截图、外部订单链接转化为高美感的数字资产，支持灵活筛选、瀑布流展示及尺寸自适应分享。

### 1.2 目标用户
- 电影、演出、展览等高频线下消费者
- 具备票根收集与分享诉求的年轻群体

## 2. 技术选型

### 2.1 核心技术栈
- **UI 框架**: SwiftUI
- **数据持久化**: SwiftData
- **架构模式**: MVVM
- **iOS 版本**: iOS 17+

### 2.2 AI 服务方案
- **OCR**: Apple Vision 框架（本地）
- **背景生成**: 第三方 API（如 OpenAI DALL-E）
- **字段识别**: AI API 或本地 ML 模型

## 3. 项目结构

```
TicketALL/
├── TicketALL/
│   ├── Models/                    # 数据模型
│   │   ├── Ticket.swift
│   │   ├── TicketType.swift
│   │   └── Tag.swift
│   ├── Views/                     # 视图层
│   │   ├── Home/                  # 首页模块
│   │   │   ├── HomeView.swift
│   │   │   ├── TicketCardView.swift
│   │   │   └── FilterView.swift
│   │   ├── AddTicket/             # 新增票据模块
│   │   │   ├── AddTicketView.swift
│   │   │   ├── ImageImportView.swift
│   │   │   └── LinkImportView.swift
│   │   ├── Profile/               # 个人中心模块
│   │   │   ├── ProfileView.swift
│   │   │   └── TagManagementView.swift
│   │   └── Components/            # 公共组件
│   │       ├── CapsuleButton.swift
│   │       └── TicketShareView.swift
│   ├── ViewModels/                # 视图模型
│   │   ├── HomeViewModel.swift
│   │   ├── AddTicketViewModel.swift
│   │   └── ProfileViewModel.swift
│   ├── Services/                  # 服务层
│   │   ├── OCRService.swift
│   │   ├── AIBackgroundService.swift
│   │   ├── LinkParserService.swift
│   │   └── TicketService.swift
│   ├── Helpers/                   # 工具类
│   │   ├── ImageProcessor.swift
│   │   └── DateFormatter+Extensions.swift
│   ├── Persistence/               # 数据持久化
│   │   └── TicketALLApp.swift
│   ├── Resources/                 # 资源文件
│   │   ├── Assets.xcassets
│   │   └── MockData/
│   └── TicketALLApp.swift         # App 入口
└── TicketALL.xcodeproj
```

## 4. 数据模型设计

### 4.1 Ticket（票据模型）
```swift
@Model
final class Ticket {
    var id: UUID
    var title: String
    var type: TicketType
    var date: Date
    var venue: String?
    var seat: String?
    var price: Double?
    var image: Data
    var originalImage: Data?
    var relatedLinks: [URL]
    var tags: [Tag]
    var createdAt: Date
    
    init(id: UUID = UUID(), 
         title: String, 
         type: TicketType, 
         date: Date, 
         venue: String? = nil, 
         seat: String? = nil, 
         price: Double? = nil, 
         image: Data, 
         originalImage: Data? = nil, 
         relatedLinks: [URL] = [], 
         tags: [Tag] = [], 
         createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.venue = venue
        self.seat = seat
        self.price = price
        self.image = image
        self.originalImage = originalImage
        self.relatedLinks = relatedLinks
        self.tags = tags
        self.createdAt = createdAt
    }
}
```

### 4.2 TicketType（票据类型）
```swift
enum TicketType: String, Codable, CaseIterable {
    case movie
    case concert
    case exhibition
    case theater
    case sports
    case custom
    
    var displayName: String {
        switch self {
        case .movie: return "电影"
        case .concert: return "演唱会"
        case .exhibition: return "展览"
        case .theater: return "话剧"
        case .sports: return "体育"
        case .custom: return "自定义"
        }
    }
    
    var iconName: String {
        switch self {
        case .movie: return "film"
        case .concert: return "music.mic"
        case .exhibition: return "photo.on.rectangle"
        case .theater: return "theatermasks"
        case .sports: return "sportscourt"
        case .custom: return "tag"
        }
    }
}
```

### 4.3 Tag（标签模型）
```swift
@Model
final class Tag {
    var id: UUID
    var name: String
    var color: String
    var isSystem: Bool
    
    init(id: UUID = UUID(), name: String, color: String, isSystem: Bool = false) {
        self.id = id
        self.name = name
        self.color = color
        self.isSystem = isSystem
    }
}
```

## 5. 核心功能模块设计

### 5.1 首页模块
- **瀑布流展示**: 使用 LazyVGrid 实现自适应瀑布流布局
- **筛选系统**: 支持按类型、时间范围、自定义标签筛选
- **视图切换**: 瀑布流/列表视图平滑切换
- **相关链接**: 票据卡片上悬挂相关链接（电影详情、场馆导航等）
- **分享功能**: 生成尺寸自适应的分享卡片

### 5.2 新增票据模块
- **图片导入流程**:
  1. 单张图片选择
  2. OCR 文字提取（Vision 框架）
  3. AI 字段判定
  4. AI 背景生成
  5. 字段定位与排版
  6. 完整图片合成
- **链接导入流程**:
  1. 粘贴链接（大麦、猫眼、淘票票等）
  2. 解析链接获取信息
  3. 应用固定模板
  4. 四角修整（裁边、圆角）

### 5.3 个人中心模块
- **标签管理**: 自定义标签创建、编辑、删除
- **类型配置**: 在系统基础上补充票据类型
- **数据统计**: 票据数量、类型分布、消费金额等
- **Mock 数据**: 多样化票据样本库

## 6. UI/UX 设计规范

### 6.1 Apple HIG 规范
- **毛玻璃效果**: 使用 .ultraThinMaterial 等材料
- **弹簧动画**: 使用 spring() 动画曲线
- **San Francisco 字体**: 遵循 Apple 字体层级
- **手势识别**: 向下滑动关闭等自然手势

### 6.2 按钮规范
- **胶囊按钮**: 底部 Tab 居中 "+" 按钮和所有主要 CTA 按钮必须使用胶囊形状
- **禁止**: 绝对禁止使用普通圆角矩形（Squircle）作为核心交互按钮

### 6.3 卡片设计
- **圆角**: 16px/24px 圆角
- **阴影**: 适度的阴影效果增强层次感
- **对比**: 卡片圆角与胶囊按钮形成对比

## 7. 数据流设计

### 7.1 票据导入数据流
```
用户选择图片
    ↓
Vision OCR 提取文字
    ↓
AI 字段识别与分类
    ↓
AI 生成纯净背景
    ↓
字段定位与排版
    ↓
合成最终图片
    ↓
SwiftData 持久化存储
    ↓
首页瀑布流展示
```

### 7.2 首页展示数据流
```
SwiftData 查询
    ↓
ViewModel 处理筛选逻辑
    ↓
HomeView 瀑布流渲染
    ↓
用户交互（筛选/切换视图）
    ↓
ViewModel 更新数据
    ↓
视图重新渲染
```

## 8. 服务层设计

### 8.1 OCRService
- 职责：使用 Vision 框架进行文字识别
- 接口：`func recognizeText(in image: UIImage) async throws -> [String]`

### 8.2 AIBackgroundService
- 职责：调用第三方 API 生成背景
- 接口：`func generateBackground(for image: UIImage) async throws -> UIImage`

### 8.3 LinkParserService
- 职责：解析外部订单链接
- 接口：`func parseLink(_ url: URL) async throws -> TicketInfo`

### 8.4 TicketService
- 职责：票据 CRUD 操作
- 接口：`func createTicket(_ ticket: Ticket) throws`、`func fetchTickets() throws -> [Ticket]`

## 9. 错误处理

### 9.1 错误类型
- `OCRSError`: OCR 识别失败
- `AIServiceError`: AI 服务调用失败
- `LinkParseError`: 链接解析失败
- `PersistenceError`: 数据持久化失败

### 9.2 错误处理策略
- 用户友好的错误提示
- 重试机制（网络请求）
- 降级方案（AI 失败时使用原图）

## 10. 测试策略

### 10.1 单元测试
- ViewModel 逻辑测试
- Service 层测试
- Helper 工具类测试

### 10.2 UI 测试
- 主要用户流程测试
- 交互反馈测试

### 10.3 Mock 数据
- 内置多样化票据样本
- 多尺寸测试数据（横版、竖版、细长条）
