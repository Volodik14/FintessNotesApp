# NumberCalculate

用于购物车或者商品货物添加以更改数量使用

主要参数 
```
/** 初始显示值 不传默认显示0  建议必传*/
@property (nonatomic, copy) NSString *baseNum;

/** 数值增减基数（倍数增减） 默认1的倍数增减 */
@property (nonatomic, assign) NSInteger multipleNum;

/** 最小值 默认且最小为0*/
@property (nonatomic, assign) NSInteger minNum;

/** 最大值  默认99999 */
@property (nonatomic, assign) NSInteger maxNum;



/** 数字框是否可以手动输入  默认可以 */
@property (nonatomic, assign) BOOL canText;

/** 是否隐藏边框线  默认显示 */
@property (nonatomic, assign) BOOL hidBorder;

/** 边框线颜色 */
@property (nonatomic, strong) UIColor *numborderColor;

/** 加减按钮颜色 */
@property (nonatomic, strong) UIColor *buttonColor;

/** 是否开启晃动  默认开启 */
@property (nonatomic, assign) BOOL isShake;
```

回调方式block跟delegate两种方式可选
```
/** 结果回传 */
@property (nonatomic, copy) void (^resultNumber)(NSString *number);
@property (nonatomic, weak) id<NumberCalculateDelegate>delegate;
```

```
number.resultNumber = ^(NSString *number) {
NSLog(@"%@>>>resultBlock>>",number);
};


- (void)resultNumber:(NSString *)number{
NSLog(@"%@>>>resultDelegate>>",number);
}
```

![参考](https://github.com/XueYangLee/NumberCalculate/blob/master/screen.gif)
