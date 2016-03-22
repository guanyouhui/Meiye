//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "TXDropDown.h"
#import "QuartzCore/QuartzCore.h"
@interface TXDropDown ()

@property(nonatomic, strong) UITableView *table;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, copy)  DropDownBlock dropDownBlock;
@property(nonatomic, assign) CGFloat contentHeight;
@end

@implementation TXDropDown
@synthesize table;
@synthesize list;


- (id)initDropDownWithFrame:(CGRect )frame list:(NSArray *)arr dropDownBlock:(DropDownBlock)block{
    _dropDownBlock=block;
    self = [super init];
    if (self) {
        // Initialization code
        _contentHeight = frame.size.height;
        
        self.frame = frame;
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        table.separatorColor = [UIColor grayColor];
        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.27];
//        table.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        [UIView commitAnimations];
        
        [self addSubview:table];
    }
    return self;
}

-(void)showDropDown {
    _isShow=YES;
    CGRect toFrame = self.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.27];
    self.frame = CGRectMake(toFrame.origin.x, 0, toFrame.size.width, _contentHeight);
    table.frame = CGRectMake(0, 0, toFrame.size.width, _contentHeight);
    [UIView commitAnimations];
}

-(void)hideDropDown{
    if (_isShow == NO) return;
    
    _isShow=NO;
    
    CGRect toFrame = self.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.27];
    self.frame = CGRectMake(toFrame.origin.x, 0, toFrame.size.width, 0);
    table.frame = CGRectMake(0, 0, toFrame.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}   


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TXDropDownCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
//    UIView * v = [[UIView alloc] init];
//    v.backgroundColor = [UIColor grayColor];
//    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    
    _dropDownBlock(c.textLabel.text);
    
}


@end
