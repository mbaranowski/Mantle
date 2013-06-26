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
            reverseBlock:^(NSNumber* num) {
                return [DDXMLNode elementWithName:@"count"
                                      stringValue:[num stringValue]];
            }];
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter* _dateFormatter;
    if (!_dateFormatter)
    {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterFullStyle];
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

- (DDXMLElement *)serializeToXMLElement
{
    DDXMLElement* root = [[DDXMLElement alloc] initWithName:@"TestModel"];
    [root addChild:[[DDXMLElement alloc] initWithName:@"name" stringValue:self.name]];
    
    DDXMLElement* userIdNode = [[DDXMLElement alloc] initWithName:@"userId" stringValue:self.userName];
    [userIdNode addAttributeWithName:@"password" stringValue:self.password];
    [root addChild:userIdNode];
    
    NSValueTransformer* countTransformer = [MTLTestModelXML countXMLTransformer];
    [root addChild:[countTransformer reverseTransformedValue:[NSNumber numberWithInteger:self.count]]];
    
    DDXMLElement* nestedNode = [[DDXMLElement alloc] initWithName:@"nested"];
    
    NSValueTransformer *dateTransformer = [MTLTestModelXML dateXMLTransformer];
    DDXMLElement* dateNode = [dateTransformer reverseTransformedValue:self.date];
    [dateNode addAttributeWithName:@"locale" stringValue:@"en_US_POSIX"];
    [nestedNode addChild:dateNode];
     
    [root addChild:nestedNode];
    
    return root;
}
@end
