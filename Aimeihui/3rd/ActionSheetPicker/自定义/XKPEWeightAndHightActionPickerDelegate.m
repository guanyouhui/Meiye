//
//  XKPEWeightAndHightActionPickerDelegate.m
//  PestatePatient
//
//  Created by YJunxiao on 16/1/7.
//  Copyright © 2016年 袁俊晓. All rights reserved.
//

#import "XKPEWeightAndHightActionPickerDelegate.h"
// **********************这个是六列的代理***********
@implementation XKPEWeightAndHightActionPickerDelegate
-(instancetype)initWithArr1:(NSArray *)arr1 Arr2:(NSArray *)arr2 arr3:(NSArray *)arr3 Arr4:(NSArray *)arr4 Arr5:(NSArray *)arr5 arr6:(NSArray *)arr6{
    if (self = [super init]) {
        _listArr1 = arr1;
        _listArr2 = arr2;
        _listArr3 = arr3;
        _listArr4 = arr4;
        _listArr5 = arr5;
        _listArr6 = arr6;
      
    }
    return self;
    
}
- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    if ([self.delegates respondsToSelector:@selector(xkwightactionSheetPickerDidSucceed:origin:)]) {
        [self.delegates xkwightactionSheetPickerDidSucceed:actionSheetPicker origin:origin];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //        pickerLabel.minimumFontSize = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];//字体加粗
         pickerLabel.font = [UIFont systemFontOfSize:17];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 6;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_listArr1 count];
    }
    else if(component == 1){
        return [_listArr2 count];
    }
    else if(component == 2){
        return [_listArr3 count];
    }else if(component == 3){
        return [_listArr4 count];
    }
    else if(component == 4){
        return [_listArr5 count];
    }else{
        return [_listArr6 count];
    }
    
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if ((component == 1) || (component == 4)) {
        return 10;
    }
    else{
        return 60;
    }
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _selectedKey1 = [_listArr1 objectAtIndex:row];
        
    } else if(component == 1){
        _selectedkey2 = [_listArr2 objectAtIndex:row];
    }
    else if(component == 2){
        _selectedkey3 = [_listArr3 objectAtIndex:row];
    }else if(component == 3){
        _selectedKey4 = [_listArr4 objectAtIndex:row];
    }
    else if(component == 4){
        _selectedkey5 = [_listArr5 objectAtIndex:row];
    }else{
        _selectedkey6 = [_listArr6 objectAtIndex:row];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_listArr1 objectAtIndex:row];
    }else if(component == 1){
        return [_listArr2 objectAtIndex:row];
    }else if(component == 2){
        return [_listArr3 objectAtIndex:row];
    }else if(component == 3){
        return [_listArr4 objectAtIndex:row];
    }else if(component == 4){
        return [_listArr5 objectAtIndex:row];
    }else{
        return [_listArr6 objectAtIndex:row];
    }
    
}

@end
