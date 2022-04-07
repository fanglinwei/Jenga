# Jenga - 基于Swift ResultBuilder优雅的构建UITableView

[![License](https://img.shields.io/cocoapods/l/Jenga.svg)](LICENSE)&nbsp;
![Swift](https://img.shields.io/badge/Swift-5.6-orange.svg)&nbsp;
![Platform](https://img.shields.io/cocoapods/p/Jenga.svg?style=flat)&nbsp;
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-4BC51D.svg?style=flat")](https://swift.org/package-manager/)&nbsp;
[![Cocoapods](https://img.shields.io/cocoapods/v/Jenga.svg)](https://cocoapods.org)

## [🇨🇳天朝子民](README_CN.md)

A library for building `UITableView` declaratively written in `Swift ResultBuilder`, just like `SwiftUI` API form, can reduce the amount of code by 80% to build tableView.

## Features

- [x] Use declarative chaining syntax to build lists Smooth coding experience Elegant and natural styling.
- [x] Rich Cell type support, support system setting styles and custom types.
- [x] Support `@propertyWrapper`, use `state` and `binding` to bind UI state
- [x] Support automatic calculation and row height
- [x] Support automatic registration of Cell
- [x] Continue to add more new features.


## Screenshot

<img src="Resources/simple.png" alt="Simple" width="80%" />

<div align="center">
<img src="Resources/setting.png" alt="Setting" width="40%" />
</div>

## Installation

#### CocoaPods - Podfile

```ruby
pod 'Jenga'
```

#### [Swift Package Manager for Apple platforms](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

Select Xcode menu `File > Swift Packages > Add Package Dependency` and enter repository URL with GUI.  
```
Repository: https://github.com/fanglinwei/Jenga
```

#### [Swift Package Manager](https://swift.org/package-manager/)

Add the following to the dependencies of your `Package.swift`:
```swift
.package(url: "https://github.com/fanglinwei/Jenga", from: "version")
```

## Usage

First make sure to import the framework:

```swift
import Jenga
```



How to initialize:

```swift
JengaEnvironment.isEnabledLog = true  //日志
JengaEnvironment.setup(JengaProvider())
```



Then you just need short code to build UITableView

```swift
@TableBuilder
var tableBody: [Table] {
			rows...
}
```



Here are some usage examples. All devices are also available as simulators:


#### `DSLAutoTable` is recommended for fast builds:

```swift
import Jenga

class ViewController: UIViewController, DSLAutoTable {

    @TableBuilder
    var tableBody: [Table] {
        TableSection {
            
            NavigationRow("设置样式")
                .onTap(on: self) { (self) in
                    self.navigationController?.pushViewController(SettingViewController(), animated: true)
                }

            NavigationRow("自定义Cell")
                .onTap(on: self) { (self) in
                    self.navigationController?.pushViewController(CustomViewController(), animated: true)
                }
        }
    }
}
```

preview:

<div align="center">
<img src="Resources/quick.png" alt="Stroke" width="40%" />
</div>

#### Custom Cell:

```swift
@TableBuilder
    var tableBody: [Table] {
        
        TableSection {
            
            TableRow<BannerCell>("image1")
                .height(1184 / 2256 * (UIScreen.main.bounds.width - 32))
                .customize { [weak self] cell in
                    cell.delegate = self
                }
            
            SpacerRow(10)
            
            TableRow<BannerCell>()
                .height(1540 / 2078 * (UIScreen.main.bounds.width - 32))
                .data("image2")
                .customize { (cell, value) in
                    print(cell, value)
                }
        }
        .headerHeight(20)
    }
```

preview:

<div align="center">
<img src="Resources/custom.png" alt="Stroke" width="40%" />
</div>


#### `State` and `Binding`:

```swift
    @State var text = "objective-c"
    
    @State var detailText = "TableView"
    
    @State var isHiddenCat = false

    // DSL
    @TableBuilder
    var tableBody: [Table] {
        
        TableSection {
            NavigationRow($text)
                .detailText($detailText)
            
            ToggleRow("显示小猫", isOn: $isHiddenCat)
                .onTap(on: self) { (self, isOn) in
                    self.isHiddenCat = isOn
                }
            
        }
        .header("Toggle")
        .rowHeight(52)
        .headerHeight(UITableView.automaticDimension)
        
        TableSection(binding: $isHiddenCat) { isOn in
            NavigationRow("🐶")
            NavigationRow("🐶")
            NavigationRow("🐶")
  
            if isOn {
                NavigationRow("🐱")
                NavigationRow("🐱")
                NavigationRow("🐱")
            }
        }
        .header("Animal")
        .headerHeight(UITableView.automaticDimension)
    }
```

Modify `State` to update UI

```swift
text = "Swift"
detailText = "Jenga"
isShowCat = true
```



preview:

<div align="center">
<img src="Resources/binding_1.png" alt="Stroke" width="40%" />
<img src="Resources/binding_2.png" alt="Stroke" width="40%" />
</div>

#### Section Binding: 

```swift
    @State var emojis: [String] = ["🐶", "🐱", "🐭", "🦁", "🐼"]
    
    // DSL
    @TableBuilder
    var tableBody: [Table] {
        
        TableSection(binding: $emojis) {
            TableRow<EmojiCell>()
                .data($0)
                .height(44)
        }
        .headerHeight(UITableView.automaticDimension)
        
        TableSection {
            TapActionRow("Random")
                .onTap(on: self) { (self) in
                    guard self.emojis.count > 3 else { return }
                    self.emojis[2] = randomEmojis[Int.random(in: 0 ... 4)]
                    self.emojis[3] = randomEmojis[Int.random(in: 0 ... 4)]
                }
            
            TapActionRow("+")
                .onTap(on: self) { (self) in
                    self.emojis.append(randomEmojis[Int.random(in: 0 ... 4)])
                }
            
            TapActionRow("-")
                .onTap(on: self) { (self) in
                    guard self.emojis.count > 0 else { return }
                    _ = self.emojis.popLast()
                }
        }
        .headerHeight(UITableView.automaticDimension)
    }
```


preview:

<div align="center">
<img src="Resources/section_binding.png" alt="Stroke" width="40%" />
</div>


#### It is also possible not to use TableSection, but I am still weighing the pros and cons of this API approach:

```swift
    @TableBuilder
    var tableBody: [Table] {
        
        TableHeader("我是头部")
        NavigationRow("设置样式")
        NavigationRow("自定义Cell")
        NavigationRow("自定义TableView")
        TableFooter("我是底部")
        
        TableHeader("第二组")
            .height(100)
        NavigationRow("cell")
    }
```

#### 自定义`DSLAutoTable`创建的`TableView`

```swift
struct JengaProvider: Jenga.JengaProvider {
    
    func defaultTableView(with frame: CGRect) -> UITableView {
        let tableView: UITableView
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: frame, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: frame, style: .grouped)
        }
        return tableView
    }
}

JengaEnvironment.setup(JengaProvider())
```



If you want to listen to `UIScrollViewDelegate` or create your own TableView, you can't use `DSLAutoTable` protocol

Just view `CustomTableViewController` in Demo

1. ######  TableDirector

   ```swift
   lazy var table = TableDirector(tableView, delegate: self)
   ```

2. ###### Describe TableBody using @TableBuilder

   ```swift
       @TableBuilder
       var tableBody: [Table]] {
           
           TableSection(binding: $array) {
               TableRow<EmojiCell>()
                   .data($0)
                   .height(44)
           }
           .headerHeight(UITableView.automaticDimension)
       }
   ```

3. ###### Update TableBody

   ```swift
   table.set(sections: tableBody)
   ```

Done, your table is ready.

For more examples, see the sample application.

## Cell height calculating strategy:

Implementation ideas come from[FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell)

You can set height to `UITableView.highAutomaticDimension` to enable automatic calculation and cache row height

Just view `AutoHeightViewController` in Demo

```swift
// row
NavigationRow()
	.height(UITableView.highAutomaticDimension)

// section
TableSection {
  rows...
}
.rowHeight(UITableView.highAutomaticDimension)
```



## `SystemRow` protocol provides chaining

| Row                     | 描述               |
| :---------------------- | ------------------ |
| `text`                  | 标题               |
| `detailText`            | 子标题(默认value1) |
| `detailText(.subtitle)` | 子标题subtitle     |
| `detailText(.value1)`   | 子标题value1       |
| `detailText(.value2)`   | 子标题value2       |
| `detailText(.none)`     | 子标题空样式       |
| `isOn`                  | 开关               |
| `height`                | 行高               |
| `estimatedHeight`       | 预估行高               |
| `selectionStyle`        | 选中样式               |
| `onTap`                 | 点击事件              |
| `customize`             | 自定义              |

## Contributing

If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.
If you extended the functionality of Jenga yourself and want others to use it too, please submit a pull request.

## Thanks for inspiration
- [LazyFish](https://github.com/zjam9333/LazyFish)
- [QuickTableViewController](https://github.com/bcylin/QuickTableViewController)
- [TableKit](https://github.com/maxsokolov/TableKit)
- [FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell)

## License

Jenga is under MIT license. See the [LICENSE](LICENSE) file for more info.

