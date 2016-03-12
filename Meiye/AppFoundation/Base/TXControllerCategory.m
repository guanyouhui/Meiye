//
//  YundxViewController+TXController.m
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "TXControllerCategory.h"
#import "MobClick.h"

@implementation KaKaViewController (TXController)

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = RGBS(243);
    
    //自定义导航条
    [self customNavigationBar];
    
    //自动添加"后退"按钮
    if (self.navigationController.viewControllers.count > 1) {
        [self customBackButton];
    }
    
    //为NavigationBar和TabBar添加阴影
    [self appendShadowToViews];
    
    //自动添加标题Label
    [self customTitleLabel];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
}




-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSString *)getUMengLogPageName {
    return [ZUtilsString isEmpty:self.navigationItem.title] ? NSStringFromClass([self class]) : self.navigationItem.title;
}

- (void)back {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setTabBarItemTitle:(NSString *)title andImageName:(NSString *)imageName andSelectedImageName:(NSString *)selectedImageName {
    
    if ([self.tabBarItem respondsToSelector:@selector(initWithTitle:image:selectedImage:)]) {
        UITabBarItem * tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selectedImageName]];
        self.tabBarItem = tabBarItem;
    }else{
        self.title = title;
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectedImageName]
                      withFinishedUnselectedImage:[UIImage imageNamed:imageName]];
    }
}

/**
 *自定义添加标题Label,用于某些界面的标题修改方便
 */
- (void)customTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18];
    titleLabel.text = self.navigationItem.title;
    self.navigationItem.titleView = titleLabel;
}

/**
 * 自定义NavigationBar，如果是一级界面，使用带Logo的导航栏背景
 */
- (void)customNavigationBar {
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    if (  [ZUtilsDevice deviceSystemVersion] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = true;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = false;
        
        self.navigationController.navigationBar.titleTextAttributes = @{
                                                                        NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                        NSFontAttributeName: [UIFont systemFontOfSize:18.0]
                                                                        };
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{
                                                                        NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                        NSFontAttributeName: [UIFont systemFontOfSize:18.0]
                                                                        };
    }
    
    [navigationBar setBackgroundImage:[ZUtilsImage getImageWithColor:RGBS(51)] forBarMetrics:UIBarMetricsDefault];
    //    [navigationBar setBackgroundColor:RGBS(51)];
    
}

- (void)customBackButton {
    
    UIButton *backButton = [self addLeftNavBarItemsWithText:@"返回" andImage:[UIImage imageNamed:@"back.png"]];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.width = 45;
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    
}

- (UIButton *)addRightNavBarItemsWithText:(NSString *)text andImage:(UIImage *)image{
    UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = CGRectMake(0, 0, 40, 40);
    [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    itemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [itemButton setTitle:text forState:UIControlStateNormal];
    [itemButton setImage:image forState:UIControlStateNormal];
    
    if ([itemButton titleForState:UIControlStateNormal]) {
        CGFloat width = [ZUtilsString estimateTextWidthByContent:text textFont:itemButton.titleLabel.font];
        itemButton.frame = CGRectMake(0, 0, width, 40);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    item.style = UIBarButtonItemStyleDone;
    
    NSMutableArray *rightItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    
    if (IOS7_OR_LATER)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        
        [rightItems addObject:negativeSeperator];
    }
    
    [rightItems addObject:item];
    
    self.navigationItem.rightBarButtonItems = rightItems;
    
    return itemButton;
}

- (UIButton *)addLeftNavBarItemsWithText:(NSString *)text andImage:(UIImage *)image{
    
    UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = CGRectMake(0, 0, 40, 40);
    [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    itemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [itemButton setTitle:text forState:UIControlStateNormal];
    [itemButton setImage:image forState:UIControlStateNormal];
    
    if ([itemButton titleForState:UIControlStateNormal]) {
        CGFloat width = [ZUtilsString estimateTextWidthByContent:text textFont:itemButton.titleLabel.font];
        itemButton.frame = CGRectMake(0, 0, width, 40);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    item.style = UIBarButtonItemStyleDone;
    
    NSMutableArray *leftItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    
    if (IOS7_OR_LATER)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        
        [leftItems addObject:negativeSeperator];
    }
    
    [leftItems addObject:item];
    self.navigationItem.leftBarButtonItems = leftItems;
    
    return itemButton;
}

/**
 * 如果系统版本小于iOS 6，则为NavigationBar和TabBar添加阴影
 */
- (void)appendShadowToViews {
    
    if (  [ZUtilsDevice deviceSystemVersion] >= 6.0f) {
        return;
    }
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [self addShadowToView:navigationBar];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    [self addShadowToView:tabBar];
}

- (UIViewController *)popToViewControllerClass:(Class)controllerClass{
    NSArray * viewControllers = self.navigationController.viewControllers;
    
    for (UIViewController * controller in viewControllers) {
        
        if ([controller isKindOfClass:controllerClass]) {
            [self.navigationController popToViewController:controller animated:YES];
            return controller;
        }
        
    }
    return nil;
}


- (void)setTabBarItemImageName:(NSString *)imageName withSelectedImageName:(NSString *)selectedImageName {
    
    if ([self.tabBarItem respondsToSelector:@selector(initWithTitle:image:selectedImage:)]) {
        UITabBarItem * tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selectedImageName]];
        self.tabBarItem = tabBarItem;
    }else{
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectedImageName]
                      withFinishedUnselectedImage:[UIImage imageNamed:imageName]];
    }
    
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
}


/**
 * 为UIView添加阴影
 */
- (void)addShadowToView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [[UIColor grayColor] CGColor];
    view.layer.shadowOpacity = 0.8f;
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#ifdef DEBUG
    NSLog(@"Class %@ dealloc -----!-----\n\n",[self class]);
#endif
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
