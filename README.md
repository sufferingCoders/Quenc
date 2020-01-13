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
|<ul><li>- [x] </li></ul>|顯示熱門回文|Must Have|在帖子下顯示Top3 熱門回文| Richard |13 Dec 2019 |
|<ul><li>- [x] </li></ul>|Like回文|Must Have|點擊愛心,喜歡Comment| Richard | 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|按讚|Must Have|使用者能對帖子按讚| Richard & Fei| 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|收藏|Must Have|使用者能收藏帖子| Richard & Fei| 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|個人資訊|Must Have|使用者能修改個人資訊| Richard| 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|已收藏的頁面|Must Have|顯示已收藏的帖子| Richard | 13 Dec 2019 |
|<ul><li>- [x] </li></ul>|我的帖子|Must Have|顯示發的帖子| Richard | 16 Dec 2019 |
|<ul><li>- [x] </li></ul>|舉報按鈕|Must Have|可以舉報回文或文章| Richard | 15 Dec 2019|
|<ul><li>- [x] </li></ul>|顯示舉報案例於管理者介面|Must Have|在管理者介面可以確認所有舉報| Richard | 15 Dec 2019|
|<ul><li>- [x] </li></ul>|舉報案例類別|Must Have|幫舉報案例加上類別| Richard | 15 Dec 2019|
|<ul><li>- [x] </li></ul>|幫文章加上類別(板)|Must Have|可以依類別尋找文章| Richard | 14 Dec 2019 |
|<ul><li>- [x] </li></ul>|編輯帖子|Must Have|作者可以編輯帖子| Richard | 14 Dec 2019|
|<ul><li>- [x] </li></ul>|Refactor|Must Have|Refore優化使用性能| Richard| 14 Dec 2019|
|<ul><li>- [x] </li></ul>|RefactorII|Must Have|Refore優化使用性能| Richard| 15 Dec 2019 |
|<ul><li>- [x] </li></ul>|版區|Must Have|對不同種的貼文顯示不同區塊| Richard| 16 Dec 2019|
|<ul><li>- [x] </li></ul>|排序|Must Have|新增最新和最熱門排序| Richard| 16 Dec 2019 |
|<ul><li>- [x] </li></ul>|增加我的貼文區塊|Must Have|顯示所有使用者貼文| Richard| 16 Dec 2019  |
|<ul><li>- [x] </li></ul>|更改Gender表示|Must Have|使用Bool代替String, 優化存儲空間| Richard| 15 Dec 2019 |
|<ul><li>- [x] </li></ul>|匿名Po文|Must Have|可在不顯示學校的情況下Po文| Richard| 16 Dec 2019 |
|<ul><li>- [x] </li></ul>|加註釋|Must Have|給所有Widgets和functions加上註釋| Richard| 16 Dec 2019|
|<ul><li>- [ ] </li></ul>|交友|Must Have|平台提供交友配對功能| 請認領 | |
|<ul><li>- [ ] </li></ul>|聊天|Must Have|平台提供文字聊天功能| Liu | |
|<ul><li>- [ ] </li></ul>|搜尋|Must Have|平台提供搜尋文章的功能| Fei | |
|<ul><li>- [ ] </li></ul>|Adding Chatroom|Must Have|Adding Chatroom to db| Richard | |



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

### ( MultiProvider 使用問題 ) Could not find the correct Provider above this MyApp Widget
Solution: 將MaterialApp下的 home 取代掉, 將使用Provider的地方移至子Widget (不要在創建MaterialApp的時候使用Provider和Consumer)


