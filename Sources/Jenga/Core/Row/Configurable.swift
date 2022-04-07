import UIKit

public protocol RowConfigurable {
    
    /// 配置 对应 cellForRow 设置内容 添加监听等
    /// - Parameter cell: cell
    func configure(_ cell: UITableViewCell)
    
    /// 恢复 对应 didEndDisplaying 移除监听等操作
    /// - Parameter cell: cell
    func recovery(_ cell: UITableViewCell)
}

public protocol ConfigurableCell: UITableViewCell {
    associatedtype CellData
    
    /// 配置 对应 cellForRow 设置内容 添加监听等
    /// - Parameter cell: cell
    func configure(with _: CellData)
    
    /// 恢复 对应 didEndDisplaying 移除监听等操作
    /// - Parameter cell: cell
    func recovery(_ cell: CellData)
}

extension ConfigurableCell {
    
    public func recovery(_ cell: CellData) {
        
    }
}
