//
//  MTLTestModelXML.h
//  Mantle
//
//  Created by Matthew Baranowski on 6/5/13.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

@interface MTLTestElementXML  : MTLModel <MTLXMLSerializing>
@property (nonatomic, copy) NSString *value;
@end

@interface MTLTestModelXML : MTLModel <MTLXMLSerializing>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, copy) NSDate* date;

@property (nonatomic, copy) NSArray* arrayOfStrings1;
@property (nonatomic, copy) NSArray* arrayOfStrings2;

- (DDXMLElement *)serializeToXMLElement;

@end
