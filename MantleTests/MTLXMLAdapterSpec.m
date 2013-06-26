//
//  MTLXMLAdapterSpec.m
//  Mantle
//
//  Created by Matthew Baranowski on 6/5/13.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import "MTLTestModel.h"
#import "MTLTestModelXML.h"
#import "DDXMLElementAdditions.h"

SpecBegin(MTLXMLAdapter)

it(@"should serialize to XML", ^{
    
    MTLTestModelXML* model = [MTLTestModelXML new];
    model.name = @"none";
    model.userName = @"user1232";
    model.password = @"password123";
    model.count = 5;
    model.date = [NSDate date];
    
    // Convert from a model objec to DDXMLElement
    DDXMLElement* element = [MTLXMLAdapter XMLElementFromModel:model];
    
    // create an xml string
    NSString* xmlString = [element prettyXMLString];
    NSLog(@"xml:\n%@", xmlString);
    
    NSError* error = nil;
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
    expect(doc).notTo.beNil();
    expect(error).to.beNil();
    
    MTLXMLAdapter* adapter = [[MTLXMLAdapter alloc] initWithXMLNode:doc
                                                         modelClass:MTLTestModelXML.class
                                                              error:&error];
	expect(adapter).notTo.beNil();
	expect(error).to.beNil();
    
    MTLTestModelXML *model2 = (id)adapter.model;
	expect(model2).notTo.beNil();
	expect(model2.name).to.equal(model.name);
	expect(model2.count).to.equal(model.count);
    expect(model2.userName).to.equal(model.userName);
    expect(model2.password).to.equal(model.password);
    
    // we are serializing date up to one second accuracy
    expect([model.date timeIntervalSinceDate:model2.date]).to.beLessThan(1.0);

});

it(@"should initialize from XML", ^{
    
    NSString* xmlString = @"<TestModel>\
        <name>none</name>\
        <userId password=\"password123\">user1232</userId>\
        <count>5</count>\
        <nested>\
            <date locale=\"en_US_POSIX\">2014-02-14T05:23:32-08:00</date>\
        </nested>\
    </TestModel>";
    
    NSError *error = nil;
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
    expect(doc).notTo.beNil();
    expect(error).to.beNil();
    
    MTLXMLAdapter* adapter = [[MTLXMLAdapter alloc] initWithXMLNode:doc
                                                         modelClass:MTLTestModelXML.class
                                                              error:&error];
	expect(adapter).notTo.beNil();
	expect(error).to.beNil();
    
    MTLTestModelXML *model = (id)adapter.model;
	expect(model).notTo.beNil();
	expect(model.name).to.equal(@"none");
	expect(model.count).to.equal(5);
    expect(model.userName).to.equal(@"user1232");
    expect(model.password).to.equal(@"password123");
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    
    NSDate* myDate;
    [formatter getObjectValue:&myDate
                         forString:@"2014-02-14T08:23:32-05:00"
                             range:nil
                        error:0];
    expect(model.date).to.equal(myDate);
});

SpecEnd