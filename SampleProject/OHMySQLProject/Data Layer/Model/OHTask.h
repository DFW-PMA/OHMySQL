//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2018 Oleg Hnidets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OHMySQLMappingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OHTask : NSManagedObject<OHMappingProtocol>

@end

NS_ASSUME_NONNULL_END

#import "OHTask+CoreDataProperties.h"
