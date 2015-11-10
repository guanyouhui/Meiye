//
//  RegionbService.h
//  sport361
//
//  Created by Jackson Fu on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaiXieBaseService.h"
#import "City.h"

@interface CityJsonResponseHandler : JsonResponseHandler

@end


@interface RegionService : PaiXieBaseService

- (NSArray *)queryCitiesWithKeywords:(NSString *)keywords;

@end
