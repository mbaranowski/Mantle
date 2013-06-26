//
//  NSValueTransformer+MTLXMLTransformerAdditions.m
//  Mantle
//
//  Created by Matthew Baranowski on 6/26/13.
//  Copyright (c) 2013 Matthew Baranowski. All rights reserved.
//

#import "NSValueTransformer+MTLXMLTransformerAdditions.h"
#import "MTLModel.h"
#import "MTLValueTransformer.h"
#import "MTLXMLAdapter.h"

@implementation NSValueTransformer (MTLXMLTransformerAdditions)

+ (NSValueTransformer *)mtl_XMLTransformerWithModelClass:(Class)modelClass {
	NSParameterAssert([modelClass isSubclassOfClass:MTLModel.class]);
	NSParameterAssert([modelClass conformsToProtocol:@protocol(MTLXMLSerializing)]);
    
	return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^ id (DDXMLNode *node) {
                if (node == nil) return nil;
                
                NSAssert([node isKindOfClass:DDXMLNode.class], @"Expected a DDXMLNode, got: %@", node);
                
                return [MTLXMLAdapter modelOfClass:modelClass fromXMLNode:node error:NULL];
            }
            reverseBlock:^ id (MTLModel<MTLXMLSerializing> *model) {
                if (model == nil) return nil;
                
                NSAssert([model isKindOfClass:MTLModel.class], @"Expected a MTLModel object, got %@", model);
                NSAssert([model conformsToProtocol:@protocol(MTLXMLSerializing)], @"Expected a model object conforming to <MTLXMLSerializing>, got %@", model);
                
                return [MTLXMLAdapter XMLElementFromModel:model];
            }];
}

+ (NSValueTransformer *)mtl_XMLArrayTransformerWithModelClass:(Class)modelClass {
	NSValueTransformer *xmlTransformer = [self mtl_XMLTransformerWithModelClass:modelClass];
    
	return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^ id (DDXMLNode *xmlNode) {
                if (xmlNode == nil) return nil;
                
                NSMutableArray *models = [NSMutableArray arrayWithCapacity:xmlNode.childCount];
                for (DDXMLNode *child in [xmlNode children]) {
                    id model = [xmlTransformer transformedValue:child];
                    if (model == nil) continue;
                    [models addObject:model];
                }
                
                return models;
            }
            reverseBlock:^ id (NSArray *models) {
                if (models == nil) return nil;
                
                NSAssert([models isKindOfClass:NSArray.class], @"Expected a array of MTLModels, got: %@", models);
                
                NSMutableArray *xmlNodes = [NSMutableArray arrayWithCapacity:models.count];
                for (MTLModel *model in models) {
                    DDXMLNode *node = [xmlTransformer reverseTransformedValue:model];
                    if (node == nil) continue;
                    
                    [xmlNodes addObject:node];
                }
                
                return xmlNodes;
            }
            ];
}

+ (NSValueTransformer *)mtl_XMLNonUniformObjectArrayTransformerWithModelClass:(Class)modelClass {
    
	return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^ id (DDXMLNode *xmlNode) {
                if (xmlNode == nil) return nil;
                
                NSMutableArray *models = [NSMutableArray arrayWithCapacity:xmlNode.childCount];
                for (DDXMLNode *child in [xmlNode children]) {
                    
                    Class classForNode = [modelClass classForParsingXML:child];
                    NSValueTransformer *xmlTransformer = [self mtl_XMLTransformerWithModelClass:classForNode];
                    
                    id model = [xmlTransformer transformedValue:child];
                    if (model == nil) continue;
                    [models addObject:model];
                }
                
                return models;
            }
            reverseBlock:^ id (NSArray *models) {
                if (models == nil) return nil;
                
                NSAssert([models isKindOfClass:NSArray.class], @"Expected a array of MTLModels, got: %@", models);
                
                NSMutableArray *xmlNodes = [NSMutableArray arrayWithCapacity:models.count];
                for (MTLModel *model in models) {
                    NSValueTransformer *xmlTransformer = [self mtl_XMLTransformerWithModelClass:[model class]];
                    DDXMLNode *node = [xmlTransformer reverseTransformedValue:model];
                    if (node == nil) continue;
                    
                    [xmlNodes addObject:node];
                }
                
                return xmlNodes;
            }
            ];
}

@end
