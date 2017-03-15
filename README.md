#SCRefresh
    
         整个功能的大致思路是利用Runtime为UIScrollView的分类增加一个属性，在
    我们的工程使用UIScrollView及其相关子类（如：UITableView）就可以当作
    属性‘点’出来，还有一个注意点是 在你自己的.h 中增加一个UIScrollView
    的实例，这个实例是用来保存当前使用刷新的控件。保存它是为了利用KVO检
    测UIScrollView两个属性的状态而作出相应的动作。在这两个基础上，我们
    就是编码 以及调试。具体遇到的问题我在代码里面已经列出。

        旧版本是将SCRefresh和SCRefreshBase这两个类结合到一块来构成一个基本的
    刷新控件。最新版本已经将两个类分开，SCRefreshBase完全作为基类，这样
    可以重新定义新的刷新控件，只要继承SCRefreshBase并实现相应的代理方法和 
    重写基类的方法。
        
       

---

#### Podfile
To integrate AFNetworking into your Xcode project using CocoaPods, specify it in your Podfile:


```
source 'https://github.com/tsc000/SCRefresh.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'SCRefresh', '~> 0.0.1'
end
```


Then, run the following command:


```
$ pod install
```

---


#####     里面关键性的注释已经写上。有不明白的地方或写得不当的地方请加QQ 767616124
    欢迎大家交流。
    
    效果图：

![运行图](https://github.com/tsc000/SCRefresh/blob/master/Refresh/test.gif)


    我已经在简书写明遇到了的问题，已经解决方法
    [简书地址](http://www.jianshu.com/p/2b765afa5b7c)
    



---

    
#      对于scrollView ,tableView 和collectionView的使用方法是一致的
    
##      ****使用方法一****
    self.tableView.refresh = [ SCRefresh refreshWithTarget:self HeaderAction:@selector(refresh) FooterAction:@selector(loadMore)];
    
    
    //下拉刷新
    - (void)refresh {
    
        //结束下拉刷新RefreshOptionHeader
         [self.tableView.refresh endRefreshRefreshStyle:RefreshOptionHeader];
        }


    //上拉加载更多
    - (void)loadMore {
     
        //结束上拉加载RefreshOptionFooter
        [self.tableView.refresh endRefreshRefreshStyle:RefreshOptionFooter];
        
    }
        
    
##        ****使用方法二****

         self.collectionView.refresh = [SCRefresh refreshWithHeader:^{
    
            //结束下拉刷新RefreshOptionHeader   
            [self.collectionView.refresh endRefreshRefreshStyle:RefreshOptionHeader];
            
        } Footer:^{

            //结束上拉加载RefreshOptionFooter
            [self.collectionView.refresh endRefreshRefreshStyle:RefreshOptionFooter];

        }];

    两个重要属性

    //加载中底部按钮显示文字
    @property (nonatomic, copy) NSString *loadingFootTitle;

    //加载完成底部按钮显示文字
    @property (nonatomic, copy) NSString *finishedFootTitle;
    

---

# SCRefreshBase 基类方法介绍
###### 主要是为了快速创建刷新控件


/** 以Block方式创建刷新任务 */

    + (instancetype)refreshWithHeader:(RefreshBlock)header Footer:(RefreshBlock)footer;

/** 结束刷新 */

    - (void)endRefreshRefreshType:(RefreshOptions)type;


/** 以Action方式创建刷新任务 */

    + (instancetype)refreshWithTarget:(id)target HeaderAction:(SEL)headerAction FooterAction:(SEL)footerAction;

/** 判断刷新状态 */

    - (BOOL)isRefreshWithRefreshType:(RefreshOptions)type;


/** 监听ContentSize改变事件 */

    - (void)scrollViewContentSizeChange:(NSDictionary *)change;

/** 监听滚动事件 */

    - (void)scrollViewContentOffsetChange:(NSDictionary *)change;

/** 为下拉刷新控件添加子控件 ，重写些方法建立自己的控件*/

    - (void)setupHeaderWithSuperview:(UIView *)newSuperview;

/** 为上拉加载更多控件添加子控件 ，重写些方法建立自己的控件*/

    - (void)setupFooterWithSuperview:(UIView *)newSuperview;

###代理方法

/** 常态*/

    - (void)normalStatus;

/** 刷新态*/

    - (void)refreshStatus;

/**下拉态*/

    - (void)pulledStatus;


/** 由常态到下拉态的过程*/

    - (void)normal2pulled:(CGFloat)contentOffSide;

/**由下拉态到常态的过程*/

    - (void)pulled2nomal:(CGFloat)contentOffSide;