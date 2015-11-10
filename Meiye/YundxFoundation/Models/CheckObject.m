//
//  CheckObject.m
//  TinySeller
//
//  Created by xhs on 15/4/23.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import "CheckObject.h"

#define CHECK_YES @"check_yes"
#define CHECK_NO @"check_no"

@interface CheckObject()
{
    NSMutableDictionary *o_selectDic;      //选择状态
    NSMutableArray *o_selectObjs;          //选中对象
    NSMutableArray *o_indexPaths;          //选中行
    
    NSArray *o_willCheckObjs;      //用于被选择的对象集合
    
}
@end

@implementation CheckObject

- (id)initWihtObjs:(NSArray *)objs
{
    self = [super init];
    if (self) {
        o_willCheckObjs = objs;
        [self initObj];
    }
    return self;
}

/**
 *  初始化对象
 */
- (void)initObj
{
    o_selectDic = [NSMutableDictionary dictionary];
    o_selectObjs = [NSMutableArray array];
    o_indexPaths = [NSMutableArray array];
}

/**
 *  字典关键字
 */
- (NSString *)getKeyWith:(NSIndexPath *)indexPath
{
    if(_o_key){
        id obj =[self getCurrentObj:indexPath];
        NSString *key = [NSString stringWithFormat:@"%@",[obj valueForKey:_o_key]];
        return key;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    return key;
}

- (void)setO_willCheck:(NSArray *)o_willCheck
{
    _o_willCheck = o_willCheck;
    o_willCheckObjs = o_willCheck;
}

- (void)setO_isGroup:(BOOL)o_isGroup
{
    _o_isGroup = o_isGroup;
}

- (void)setO_style:(CheckStyle)o_style
{
    _o_style = o_style;
}

- (void)setO_key:(NSString *)o_key
{
    _o_key = o_key;
    
    [self setDefalutObjs];
}

/**
 *  初始化默认选中对像
 */
- (void)setO_defalutObjs:(NSArray *)o_defalutObjs
{
    _o_defalutObjs = o_defalutObjs;
    
    [self setDefalutObjs];
}

- (void)setDefalutObjs
{
    if (!_o_key || _o_defalutObjs.count<=0) {
        return;
    }
    
    for (id defalut in _o_defalutObjs) {
        NSString *defalutKey = [NSString stringWithFormat:@"%@",[defalut valueForKey:_o_key]];
        [o_selectDic setObject:CHECK_YES forKey:defalutKey];

        NSIndexPath *indexPath = [self getIndexPath:defalut];
        [o_indexPaths addObject:indexPath];
        
        id object = [self getCurrentObj:indexPath];
        [o_selectObjs addObject:object];
        
        
//        for(id obj in o_willCheckObjs) {
//            NSString *key = [NSString stringWithFormat:@"%@",[obj valueForKey:_o_key]];
//            if ([key isEqual:defalutKey]) {
//                [o_selectObjs addObject:obj];
//                break;
//            }
//        }
    }
}

/**
 *  获取当前对象
 */
- (id)getCurrentObj:(NSIndexPath *)indexPath
{
    if(o_willCheckObjs.count == 0) return nil;
    id obj = _o_isGroup?o_willCheckObjs[indexPath.section][indexPath.row]
                       :o_willCheckObjs[indexPath.row];
    return obj;
}

/**
 *  通过对象得到IndexPath(key值)
 */
- (NSIndexPath *)getIndexPath:(id)obj
{
    NSIndexPath *indexPath = nil;
    if(!_o_isGroup){
        for (int i = 0;i<o_willCheckObjs.count;i++) {
            id willObj = o_willCheckObjs[i];
            id key1 = [obj valueForKey:_o_key];  //传入对象
            id key2 = [willObj valueForKey:_o_key]; //整体数组
            //找到位置。。
            if ([key1 isEqual: key2]) {
                indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }else{
        for (int i = 0; i<o_willCheckObjs.count; i++) {
            NSArray *items = o_willCheckObjs[i];
            for (int j = 0; j<items.count;j++) {
                id willObj = items[j];
                NSString *str1 = [obj valueForKey:_o_key];  //传入对象
                NSString *str2 = [willObj valueForKey:_o_key]; //整体数组
                //找到位置。。
                if ([str1 isEqual: str2]) {
                    indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    break;
                }
            }
        }
    }
    return indexPath;
}


/**
 *  设置选中状态
 */
- (void)setSelectStateWith:(NSIndexPath *)indexPath
{
    NSString *key = [self getKeyWith:indexPath];
    if ([[o_selectDic objectForKey:key] isEqualToString:CHECK_YES]) {
        
        switch (_o_style) {
            case CheckStyle_simple:
            {
              NSIndexPath *selectIndexPath = o_indexPaths[0];
              if (o_selectObjs.count>0 && selectIndexPath == indexPath) {
                  //当前选中 什么也不做
                  return;
              }
            }
                break;
            case CheckStyle_simpleOver:
            {
                [o_selectObjs removeAllObjects];
                [o_indexPaths removeAllObjects];
                
                [o_selectDic setObject:CHECK_NO forKey:key];
            }
                break;
            case CheckStyle_multi:
            {
                id obj = [self getCurrentObj:indexPath];
                [o_selectObjs removeObject:obj];
                [o_indexPaths removeObject:indexPath];
                
                [o_selectDic setObject:CHECK_NO forKey:key];
            }
                break;
            default:
                break;
        }
    }else{
        switch (_o_style) {
            case CheckStyle_simple:
            case CheckStyle_simpleOver:
            {
                [o_selectObjs removeAllObjects];
                [o_indexPaths removeAllObjects];
                
                [o_indexPaths addObject:indexPath];
                id obj = [self getCurrentObj:indexPath];
                if (obj) {
                        [o_selectObjs addObject:obj];
                }
                
                [o_selectDic removeAllObjects];
                [o_selectDic setObject:CHECK_YES forKey:key];
            }
                break;
            case CheckStyle_multi:
            {
                id obj = [self getCurrentObj:indexPath];
                if (obj) {
                    [o_selectObjs addObject:obj];
                }
                [o_indexPaths addObject:indexPath];
                
                
                [o_selectDic setObject:CHECK_YES forKey:key];
            }
            default:
                break;
        }
    }
    
    if (_o_delegate && [_o_delegate respondsToSelector:@selector(getSelectObjs:)]) {
        [_o_delegate getSelectObjs:o_selectObjs];
    }

    if (_o_delegate && [_o_delegate respondsToSelector:@selector(getSelectIndexs:)]) {
        [_o_delegate getSelectIndexs:o_indexPaths];
    }
}

/**
 *  获取选中状态
 */
- (BOOL)isCheckWith:(NSIndexPath *)indexPath
{
    NSString *key = [self getKeyWith:indexPath];
    BOOL isCheck = [[o_selectDic objectForKey:key]isEqualToString:CHECK_YES]?YES:NO;
    return isCheck;
}

/**
 *  获取选中对象结果
 */
- (NSArray *)getCheckObjs
{
    return o_selectObjs;
}

/**
 *  获取选中行
 */
- (NSArray *)getCheckPaths
{
    return o_indexPaths;
}

/**
 *  取消所有选择 清除所有对象
 */
- (void)cancelOver
{
    [o_indexPaths removeAllObjects];
    [o_selectObjs removeAllObjects];
    [o_selectDic removeAllObjects];
}

/**
 *  取消某个对象
 */
- (void)cancelObj:(id)obj
{
    [o_selectDic removeObjectForKey:[obj valueForKey:_o_key]];
    
    //获取IndexPath
    NSIndexPath *indexPath = [self getIndexPath:obj];
    if (indexPath) {
        NSArray *indexPaths = o_indexPaths;
        for (NSIndexPath *index in indexPaths) {
            if (index.section==indexPath.section&&index.row==indexPath.row) {
                [o_indexPaths removeObject:index];
                break;
            }
        }
    }
    
    NSArray *objs = o_selectObjs;
    for (id objcet in objs) {
        id key1 = [obj valueForKey:_o_key];  //传入对象key
        id key2 = [objcet valueForKey:_o_key];  //选择的对象当前循环对象
        
        if ([key1 isEqual:key2]) {
            [o_selectObjs removeObject:objcet];
            break;
        }
    }
    
}

@end
