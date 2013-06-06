//
//  MTLTestModelXML.m
//  Mantle
//
//  Created by Matthew Baranowski on 6/5/13.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import "MTLTestModelXML.h"
#import "DDXMLElementAdditions.h"

#import "DDXML.h"

@implementation MTLTestModelXML

+ (NSString*)XPathPrefix {
    return @"./TestModel/";
}
+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{ @"userName": @"userId",
              @"date": @"nested/date",
              @"password": @"userId/@password"
           };
}

+ (NSValueTransformer *)countXMLTransformer {
	return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^(DDXMLNode *node) {
                return @([node stringValue].integerValue);
            }
            reverseBlock:^(NSNumber *num) {
                return [DDXMLNode elementWithName:@"count" stringValue:[num stringValue]];
            }];
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter* _dateFormatter;
    if (!_dateFormatter)
    {
        _dateFormatter = [NSDateFormatter new];
    }
    
    return _dateFormatter;
}

+ (NSValueTransformer *)dateXMLTransformer {
	return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^id(DDXMLNode *node) {
                
                NSDateFormatter* formatter = [MTLTestModelXML dateFormatter];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                
                NSString* locale = @"en_US_POSIX";
                if ([node kind] == DDXMLElementKind) {
                    DDXMLElement* element = (DDXMLElement*)node;
                    DDXMLNode* node = [element attributeForName:@"locale"];
                    locale = [node stringValue];
                }
                
                [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:locale]];
                
                
                id myDate;
                NSError* error;
                if (![formatter getObjectValue:&myDate
                                     forString:[node stringValue]
                                         range:nil
                                         error:&error]) {
                    return nil;
                }
                
                return myDate;
            }
            reverseBlock:^(NSDate *date) {
                NSDateFormatter* formatter = [MTLTestModelXML dateFormatter];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                return [DDXMLNode elementWithName:@"date" stringValue:[formatter stringFromDate:date] ];
            }];
}
@end
