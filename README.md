# QuenC 昆客

A new Flutter project.

# 待討論
- [ ] 版面設計 (主.副顏色) 
- [ ] Logo設計
- [ ] 文案宣傳 
- [ ] 初創板塊


# 待實現
- [ ] 註冊（校用Email）
- [ ] Email認證 
- [ ] 登入 
- [ ] 發帖功能
- [ ] 回文功能
- [ ] 按讚功能
- [ ] 收藏功能
- [ ] 交友功能
- [ ] 搜尋功能
- [ ] 熱度排列演算法

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
