软件需求

一、支持平台

iOS 9.0以上系统
二、开发环境

Xcode 8及更高版本

导入SDK

一、通过cocoapods集成
1、pod "VEENUMCONFIGER", :git => 'https://github.com/vefans/VEENUMCONFIGER.git'
2、如果项目中没有demo中的以下三个功能时，通过pod "VEENUMCONFIGER/ExcludeDemoBundle", :git => 'https://github.com/vefans/VEENUMCONFIGER.git'来集成，以减少APP大小
    （1）音乐相册示例-API实现（仿Quik）
    （2）创意搞怪小视频-API实现
    （3）字说-字说（API）

接下来执行：
pod install

二、通过 github 下载集成

下载完成后将库文件夹拖入到工程中，并勾选上 Copy items if needed
