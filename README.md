# CHTape
A lightweight &amp; fast Objective-C implementation of a doubly linked list, including a cursor for easy traversal.

## Installation

#### CocoaPods
CHTape can be easily installed with [CocoaPods](http://cocoapods.org). Just add this line to the Podfile
```
pod 'CHTape', :git => 'https://github.com/chris-huxtable/CHTape.git'
```

#### Manual install
Copy CHTape.{h,m}, CHMutableTape.{h,m}, CHTapeCursor.{h,m} to your project. 
This collection does not support ARC due to technical and performance issues. To use this with ARC add the compiler flag `-fno-objc-arc` to the 'Compile Sources' build phase of your project for `CHTape.m`, `CHMutableTape.m`, and `CHTapeCursor.m`.
