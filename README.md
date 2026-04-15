# TicketALL

票据自动归档与展示 App - 利用 AI 技术将纸质票据、电子截图、外部订单链接转化为高美感的数字资产。

## 技术栈

- **UI 框架**: SwiftUI
- **数据持久化**: SwiftData
- **架构模式**: MVVM
- **iOS 版本**: iOS 17+

## 项目结构

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
│   │   │   └── TicketCardView.swift
│   │   ├── AddTicket/             # 新增票据模块
│   │   ├── Profile/               # 个人中心模块
│   │   └── Components/            # 公共组件
│   │       └── CapsuleButton.swift
│   ├── ViewModels/                # 视图模型
│   │   └── HomeViewModel.swift
│   ├── Services/                  # 服务层
│   ├── Helpers/                   # 工具类
│   ├── Resources/                 # 资源文件
│   └── TicketALLApp.swift         # App 入口
└── TicketALL.xcodeproj
```

## 核心功能

### 首页模块
- ✅ 瀑布流布局展示票据卡片
- ✅ 按类型筛选
- ✅ 瀑布流/列表视图切换
- ✅ 票据详情页
- ✅ 相关链接悬挂

### 设计规范
- ✅ Apple HIG 设计规范
- ✅ 胶囊按钮（类型标签、链接按钮）
- ✅ 卡片 20px 圆角
- ✅ 毛玻璃效果
- ✅ 弹簧物理动画

## 已完成

- ✅ 项目设计文档
- ✅ 数据模型（Ticket, TicketType, Tag）
- ✅ HomeView（首页瀑布流）
- ✅ TicketCardView（票据卡片）
- ✅ CapsuleButton（胶囊按钮组件）
- ✅ HomeViewModel（首页视图模型）
- ✅ MainTabView（底部导航）

## 待开发

- 📋 新增票据模块（图片导入、链接导入）
- 📋 AI OCR 识别
- 📋 AI 背景生成
- 📋 分享功能
- 📋 个人中心完整功能
