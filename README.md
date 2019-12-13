# QuenC 昆客

A new Flutter project.

# 待討論
- [ ] 版面設計 (主.副顏色) 
- [ ] Logo設計
- [ ] 文案宣傳 
- [ ] 初創板塊
- [ ] 熱度排列演算法


# 待實現

|完成|作物|優先級|描述|耕種人|完成時間|
|:---:|:---:|:---:|:---:|:---:|:---:|
|<ul><li>- [x] </li></ul>|註冊|Must Have| 提供註冊功能| Richard | 06 Dec 2019|
|<ul><li>- [x] </li></ul>|Email認證|Must Have|認證學校Email| Richard | 06 Dec 2019|
|<ul><li>- [x] </li></ul>|登入|Must Have|Firebase 學校Email登入功能| Richard | 06 Dec 2019|
|<ul><li>- [x] </li></ul>|發帖|Must Have|使用者登入後能發帖| Richard | 08 Dec 2019 |
|<ul><li>- [x] </li></ul>|發帖時能加入圖片|Must Have|加入圖片到帖子裡面| Richard | 09 Dec 2019 |
|<ul><li>- [x] </li></ul>|顯示帖子ListView|Must Have|能使用Card的方式瀏覽貼文| Richard | 08 Dec 2019 |
|<ul><li>- [x] </li></ul>|顯示帖子Trailing圖片|Must Have|在Trailing的地方顯示PreviewImage| Richard | 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|儲存和顯示MarkDown|Must Have|儲存MarkDown到Firestore, 用RichText顯示| Richard | 10 Dec 2019 |
|<ul><li>- [x] </li></ul>|回文|Must Have|使用者能在帖子下回文| Richard | 13 Dec 2019|
|<ul><li>- [x] </li></ul>|顯示回文|Must Have|在帖子下顯示回文| Richard | 13 Dec 2019|
|<ul><li>- [x] </li></ul>|Like回文|Must Have|點擊愛心,喜歡Comment| Richard | 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|按讚|Must Have|使用者能對帖子按讚| Richard| 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|收藏|Must Have|使用者能收藏帖子| Richard| 13 Dec 2019 |
|<ul><li>- [ ] </li></ul>|已收藏的頁面|Must Have|顯示已收藏的帖子| 請認領 ||
|<ul><li>- [x] </li></ul>|Refactor|Must Have|Refore優化使用性能| Richard| |
|<ul><li>- [ ] </li></ul>|交友|Must Have|平台提供交友配對功能| 請認領 | |
|<ul><li>- [ ] </li></ul>|聊天|Must Have|平台提供文字聊天功能| Liu | |
|<ul><li>- [ ] </li></ul>|搜尋|Must Have|平台提供搜尋文章的功能| 請認領 | |


## Flutter 資源

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [online documentation](https://flutter.dev/docs)




## 滿地都是坑

### Execution failed for task ':app:transformDexArchiveWithExternalLibsDexMergerForDebug'
Solution:


在應用層級的build.gradle (android/app/build.gradle) 加入  “multiDexEnabled true”

```gradle
defaultConfig {

        applicationId "com.hlc.quenc"
        
        minSdkVersion 16
        
        targetSdkVersion 29
        
        versionCode flutterVersionCode.toInteger()
        
        versionName flutterVersionName
        
        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
        
        multiDexEnabled true //增加這個
        
        }
```


### A problem occurred evaluating project ':app'.

Solution:

更改 android/build.gradle 中的 

```
    dependencies {
        classpath 'com.android.tools.build:gradle:3.2.1'
        classpath 'com.google.gms:google-services:4.2.0' // 將 4.3.2 降為 4.2.0        
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }

```


### Execution failed for task ':app:preDebugBuild'.

Solution: 
更改 android/build.gradle 中的 


```

buildscript {
    ext.kotlin_version = '1.3.0' // 1.2.71 => 1.3.0
    repositories {
        google()
        jcenter()
    }

   dependencies {
        classpath 'com.android.tools.build:gradle:3.3.1' // 3.2.1 => 3.3.1
        classpath 'com.google.gms:google-services:4.2.0'      
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }

}
    
```
