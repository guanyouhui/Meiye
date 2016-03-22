//
//  AddressSelectView.m
//  TinySeller
//
//  Created by tingxie on 15/5/6.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import "TXAddressView.h"
#import "AreaService.h"
#import "Area.h"

typedef NS_ENUM(NSInteger, AddressPickerType) {
    AddressPickerType_Province,
    AddressPickerType_City,
    AddressPickerType_Area
};

#define QUERY_PROVINCE_TASK  0
#define QUERY_CITY_TASK      1
#define QUERY_AREA_TASK      2

@interface TXAddressView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    AreaService *areaService;
    Area *dProvince;
    Area *dCity;
    Area *dArea;
    NSMutableArray *provinces;
    NSMutableArray *cities;
    NSMutableArray *areas;
    
    NSString * selectedAddress;
}
@property (strong, nonatomic) IBOutlet UIPickerView *o_addressPickerView;

@property (nonatomic,assign) TXAddressType o_addressType;//控件类型
@property (nonatomic,assign) NSUInteger o_columnCount;//列数


@end

@implementation TXAddressView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCommonData];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommonData];
    }
    return self;
}

- (void)awakeFromNib{
    
    [self getTaskProvinces];
}

- (void)initCommonData{
    
    _o_addressType = TXAddressType_Default;
    _o_columnCount = 3;
    
    areaService = [[AreaService alloc] init];
    
    dProvince = [[Area alloc] init];
    dCity = [[Area alloc] init];
    dArea = [[Area alloc] init];
}

#pragma mark - 实例方法
- (void)showAddress:(NSString *)currentAddress type:(TXAddressType)type{
    _o_addressType = type;
    
    if (_o_addressType == TXAddressType_Default ||
        _o_addressType == TXAddressType_ProvinceCityArea) {
        _o_columnCount = 3;
    }else if(_o_addressType == TXAddressType_ProvinceCity){
        _o_columnCount = 2;
    }else if(_o_addressType == TXAddressType_Province){
        _o_columnCount = 1;
    }
    
    if ([currentAddress isEqualToString:selectedAddress]) {
        [self animateShowPickerView:YES];
        return;
    }
    
    NSArray * addressArr = [currentAddress componentsSeparatedByString:@"-"];
    
    @try {
        dProvince.o_name = addressArr[0];
        dCity.o_name = addressArr[1];
        dArea.o_name = addressArr[2];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
        
        NSInteger provinceRow = [self queryItems:provinces andName:dProvince.o_name];
        [_o_addressPickerView selectRow:provinceRow inComponent:AddressPickerType_Province animated:YES];
        [self pickerView:_o_addressPickerView didSelectRow:provinceRow inComponent:AddressPickerType_Province];
        dProvince.o_name = nil;
        
        [self animateShowPickerView:YES];
    }
}

- (void)hidden{
    
    [self animateShowPickerView:NO];
}
/*
 * 按指定名字找出位置，空则默认返回 0
 */
- (NSInteger) queryItems:(NSArray *)items andName:(NSString *)name{
    if ([ZUtilsString isEmpty:name]) {
        return 0;
    }
    
    for (int i = 0; i < items.count; i++) {
        Area * item = items [i];
        if ([item.o_name isEqualToString:name]) {
            return i;
        }
    }
    return 0;
}

#pragma mark - 确认选择
- (IBAction)confirmSelectAction:(id)sender {
    selectedAddress = [NSString string];
    
    if (provinces.count > 0 && _o_columnCount > 0) {
        Area * province = [provinces objectAtIndex:[_o_addressPickerView selectedRowInComponent:AddressPickerType_Province]];
        selectedAddress = [selectedAddress stringByAppendingFormat:@"%@", province.o_name];
    }
    if (cities.count > 0 && _o_columnCount > 1) {
        Area * city = [cities objectAtIndex:[_o_addressPickerView selectedRowInComponent:AddressPickerType_City]];
        selectedAddress = [selectedAddress stringByAppendingFormat:@"-%@", city.o_name];
    }
    
    if (areas.count > 0 && _o_columnCount > 2) {
        Area * area = [areas objectAtIndex:[_o_addressPickerView selectedRowInComponent:AddressPickerType_Area]];
        selectedAddress = [selectedAddress stringByAppendingFormat:@"-%@", area.o_name];
    }
    
    if ([self.o_delegate respondsToSelector:@selector(addressView:didSeletedAddress:)]) {
        [self.o_delegate addressView:self didSeletedAddress:selectedAddress];
    }
    [self hidden];
}

#pragma mark - PickerViewAnimation
/*
 * 选择控件动画弹出弹入。
 */
- (void)animateShowPickerView:(BOOL)show {
    
    if (show) {
        
        [_o_addressPickerView reloadAllComponents];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.y=show?(self.superview.height-self.height) : self.superview.height;
    }];
}

#pragma mark -- UIPickerViewDataSource, UIPickerViewDelegate implementation

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _o_columnCount;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case AddressPickerType_Province:
            return provinces.count;
            
        case AddressPickerType_City:
            return cities.count;
            
        case AddressPickerType_Area:
            return areas.count;
            
        default:
            break;
    }
    return 0;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case AddressPickerType_Province:
            return ((Area *)[provinces objectAtIndex:row]).o_name;
            
        case AddressPickerType_City:
            return ((Area *)[cities objectAtIndex:row]).o_name;
            
        case AddressPickerType_Area:
            return ((Area *)[areas objectAtIndex:row]).o_name;
            
        default:
            break;
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Area *param = nil;
    
    switch (component) {
        case AddressPickerType_Province: {
            //超过1列
            if (_o_columnCount > 1) {
                param = [provinces objectAtIndex:row];
                [self getTaskCities:param];
            }
            
        }
            break;
            
        case AddressPickerType_City: {
            
            //超过2列
            if (_o_columnCount > 2) {
                param = [cities objectAtIndex:row];
                [self getTaskArea:param];
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - GetTask

- (void)getTaskProvinces{
    
    NSArray * aResult = [areaService queryProvince];
    if (aResult.count > 0) {
        provinces = [NSMutableArray arrayWithArray:aResult];
        [_o_addressPickerView reloadComponent:AddressPickerType_Province];
        
        //省不为空 且 列数大于1
        if (provinces.count > 0 && _o_columnCount > 1) {
            
            [self getTaskCities:[provinces firstObject]];
        }
    }
}

- (void)getTaskCities:(Area *)region{
    
    NSArray * aResult = [areaService queryCity:region.entityId];
    if (aResult.count > 0) {
        cities = [NSMutableArray arrayWithArray:aResult];
        [_o_addressPickerView reloadComponent:AddressPickerType_City];
        
        //城市不为空 且 列数大于1
        if (cities.count > 0) {
            
            //刷新 city
            NSInteger cityRow = [self queryItems:cities andName:dCity.o_name];
            dCity.o_name = nil;
            [_o_addressPickerView selectRow:cityRow inComponent:AddressPickerType_City animated:YES];
            
            //列数大于2 刷新 区域列
            if (_o_columnCount > 2) {
                [self pickerView:_o_addressPickerView didSelectRow:cityRow inComponent:AddressPickerType_City];
            }
            
        } else {
            [areas removeAllObjects];
            //列数大于2 刷新 区域列
            if (_o_columnCount > 2) {
                [_o_addressPickerView reloadComponent:AddressPickerType_Area];
            }
            
        }
    }
}


- (void)getTaskArea:(Area *)region{
    
    NSArray * aResult = [areaService queryDistrict:region.entityId];
    if (aResult.count > 0) {
        areas = [NSMutableArray arrayWithArray:aResult];
        
        //列数大于2 刷新 区域列
        if (_o_columnCount > 2) {
            [_o_addressPickerView reloadComponent:AddressPickerType_Area];
            
            if (areas.count > 0) {
                
                NSInteger areaRow = [self queryItems:areas andName:dArea.o_name];
                [_o_addressPickerView selectRow:areaRow inComponent:AddressPickerType_Area animated:YES];
                dArea.o_name = nil;
            }
        }
    }
}

- (void)dealloc{
    NSLog(@"dealloc：%@",self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
