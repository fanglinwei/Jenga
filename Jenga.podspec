Pod::Spec.new do |s|

s.name         = "Jenga"
s.version      = "1.0.0"
s.summary      = "在UIKit里像SwiftUI一样搭建TableView"

s.homepage     = "https://github.com/fanglinwei/Jenga"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "fanglinwei" => "lw_fun@163.com" }

s.source       = { :git => "https://github.com/fanglinwei/Jenga.git", :tag => s.version }

s.requires_arc = true

s.swift_versions = ["5.0"]

s.frameworks = "Foundation"
s.ios.frameworks = "UIKit"

s.ios.deployment_target = '11.0'

s.source_files  = ["Sources/*.swift"]

end
