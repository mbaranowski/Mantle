//
//  MTLTestModelXML.m
//  Mantle
//
//  Created by Matthew Baranowski on 6/5/13.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import "MTLTestModelXML.h"
#import "DDXMLElementAdditions.h"
#import "NSValueTransformer+MTLXMLTransformerAdditions.h"
#import "DDXML.h"

@implementation MTLTestElementXML
+ (NSString*)XPathPrefix {
    return @"self::element/";
}
+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{ @"value": @"text()" };
}
@end

@implementation MTLTestModelXML

+ (NSString*)XPathPrefix {
    return @"./TestModel/";
}
+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{ @"userName": @"userId",
              @"date": @"nested/date",
              @"password": @"userId/@password",
              @"arrayOfStrings1": @"arrayOfStrings1/element",
              @"arrayOfStrings2": @"element"        
           };
}

+ (NSValueTransformer *)countXMLTransformer {
	return [MTLValueTransformer mtl_XMLTransformerForInteger];
}

+ (NSValueTransformer *)dateXMLTransformer {
    return [NSValueTransformer mtl_XMLTransformerForDateWithFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
}

+(NSValueTransformer*)arrayOfStrings1XMLTransformer {
    return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[MTLTestElementXML class]];
}

+(NSValueTransformer*)arrayOfStrings2XMLTransformer {
    return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[MTLTestElementXML class]];
}

- (DDXMLElement *)serializeToXMLElement
{
    DDXMLElement* root = [[DDXMLElement alloc] initWithName:@"TestModel"];
    [root addChild:[[DDXMLElement alloc] initWithName:@"name" stringValue:self.name]];
    
    DDXMLElement* userIdNode = [[DDXMLElement alloc] initWithName:@"userId" stringValue:self.userName];
    [userIdNode addAttributeWithName:@"password" stringValue:self.password];
    [root addChild:userIdNode];
    
    DDXMLElement* countElement = [DDXMLNode elementWithName:@"count"
                                               stringValue:[[MTLTestModelXML countXMLTransformer] reverseTransformedValue:@(self.count)]];
    [root addChild:countElement];
    
    DDXMLElement* nestedNode = [[DDXMLElement alloc] initWithName:@"nested"];
    
    NSValueTransformer *dateTransformer = [MTLTestModelXML dateXMLTransformer];
    DDXMLElement* dateNode = [[DDXMLElement alloc] initWithName:@"date"
                                                    stringValue:[dateTransformer reverseTransformedValue:self.date]];
    [dateNode addAttributeWithName:@"locale" stringValue:@"en_US_POSIX"];
    [nestedNode addChild:dateNode];
     
    [root addChild:nestedNode];
    
    return root;
}
@end
