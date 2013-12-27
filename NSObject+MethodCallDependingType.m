//
//  NSObject+MethodCallDependingType.m
//
//  Created by Jean Lebrument on 12/27/13.
//  Github: JeanLebrument
//

#import <objc/runtime.h>
#import "NSObject+MethodCallDependingType.h"

@implementation MethodsForTypeKey

@synthesize methodNameForRouting;
@synthesize specificsMethodsName;

- (id)init
{
    if ((self = [super init]))
    {
        methodNameForRouting = nil;
        specificsMethodsName = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end

@implementation NSObject (RouterMethodsDependingOnType)

static char const * const kProtocolMethodForRoutingTagKey = "kProtocolMethodForRouting";
static char const * const kDictionnaryMethodForRoutingTagKey = "kDictionnaryMethodForRouting";

- (NSString *)protocol
{
    NSString *prtcl = objc_getAssociatedObject(self, kProtocolMethodForRoutingTagKey);
    
    if (prtcl == nil)
    {
        prtcl = @"DependingOn";
        objc_setAssociatedObject(self, kProtocolMethodForRoutingTagKey, prtcl, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return prtcl;
}

- (void)setProtocol:(NSString *)protocol
{
    objc_setAssociatedObject(self, kProtocolMethodForRoutingTagKey, protocol, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)methodsForRouting
{
    return objc_getAssociatedObject(self, kDictionnaryMethodForRoutingTagKey);
}

- (void)setMethodsForRouting:(NSDictionary *)dictionnary
{
    objc_setAssociatedObject(self, kDictionnaryMethodForRoutingTagKey, dictionnary, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/*
 ** @parameter: typeList - Array containing the different types of key that the user need to route his methods.
 ** @parameter: className - The class to get the method names.
 ** Store the class methods name which contains a type from the "typesList" given in paramter
 */
- (void)constructMethodsListForRouting:(NSArray *)typesList FromClass:(Class)className
{
    unsigned int numMethods;
    Method *methods = class_copyMethodList(className, &numMethods);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    // Loop on each type contains on "typesList" parameter
    for (NSString *typeKey in typesList)
    {
        #ifdef DEBUG_BUILD
            NSLog(@"type key: %@\n", typeKey);
        #endif
        
        for (NSUInteger i = 0; i < numMethods; i++)
        {
            // Get class method name
            NSString *methodName = NSStringFromSelector(method_getName(methods[i]));
            NSUInteger range;
            NSString *typeValue;
            
            #ifdef DEBUG_BUILD
                NSLog(@"method name %@ for type key: %@\n", methodName, typeKey);
            #endif
            
            if ([methodName hasSuffix:@":"]) // Remove the last ":" in the method name to find it in dictionnary
            {
                methodName = [methodName substringToIndex:[methodName length] - 1];
            }
            
            // Find in the string the protocol concatenated with the type key
            if ((range = [methodName rangeOfString:[NSString stringWithFormat:@"%@%@", [self protocol], typeKey]].location) != NSNotFound)
            {
                #ifdef DEBUG_BUILD
                    NSLog(@"method founded for type key: %@ => %@\n", typeKey, methodName);
                #endif
                
                MethodsForTypeKey *subClass;
                
                // If the type key is not already stored in the dictionary, create it.
                if ((subClass = [dic objectForKey:typeKey]) == nil)
                {
                    subClass = [[MethodsForTypeKey alloc] init];
                    
                    // The begining of the method before the "protocol"
                    subClass.methodNameForRouting = [methodName substringToIndex:range];
                    
                    #ifdef DEBUG_BUILD
                        NSLog(@"methodNameForRouting: %@\n", subClass.methodNameForRouting);
                    #endif
                    
                    // Add to the dictionary
                    [dic setObject:subClass forKey:typeKey];
                }
                
                // Get the type value stored after the type key in the method name
                typeValue = [methodName substringFromIndex:range + [self protocol].length + typeKey.length];
                
                #ifdef DEBUG_BUILD
                    NSLog(@"specificsMethodName: %@\n", typeValue);
                #endif
                
                // If the type value is not already stored in the array specificsMethodsName, add it.
                if ([subClass.specificsMethodsName indexOfObjectIdenticalTo:typeValue] == NSNotFound)
                {
                    [subClass.specificsMethodsName addObject:typeValue];
                }
                
            }
        }
    }
    
    // save dictionnary
    [self setMethodsForRouting:dic];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

/*
 ** @parameter: methodNameForRoute - the begining of the method name before the "protocol" string
 ** @parameter: typeKey - The key type
 ** @parameter: typeValue - the value type
 ** @parameter: params - Parameter(s) to send through the selector
 ** Find the specific method thanks to the parameter and call it through performSelector.
 */
- (void)callRoutedMethod:(NSString *)methodNameForRoute withTypeKey:(NSString *)typeKey andTypeValue:(NSString *)typeValue andParameters:(id)params
{
    MethodsForTypeKey *subClass;
    
    // if the type key is found in the dictionnary
    if ((subClass = [[self methodsForRouting] objectForKey:typeKey]))
    {
        // if the type value is found in the array
        if ([subClass.specificsMethodsName indexOfObject:typeValue] != NSNotFound)
        {
            // Append the selector string name
            NSMutableString *selectorName = [[NSMutableString alloc] initWithString:methodNameForRoute];

            [selectorName appendString:[self protocol]];
            [selectorName appendString:typeKey];
            [selectorName appendString:typeValue];
            
            #ifdef DEBUG_BUILD
                NSLog(@"selector name : %@\n", selectorName);
            #endif
            
            // If "params" is not null, add a ":" at the end of the selector name to specify to the selector that there is a param
            if (params != nil)
            {
                [selectorName appendString:@":"];
                
                if ([self respondsToSelector:NSSelectorFromString(selectorName)])
                {
                    [self performSelector:NSSelectorFromString(selectorName) withObject:params];
                }
            }
            else
            {
                if ([self respondsToSelector:NSSelectorFromString(selectorName)])
                {
                    [self performSelector:NSSelectorFromString(selectorName)];
                }
            }
        }
        else
        {
            #ifdef DEBUG_BUILD
                NSLog(@"value for type not found: %@\n", typeValue);
            #endif
        }
    }
    else
    {
        #ifdef DEBUG_BUILD
            NSLog(@"type not found: %@\n", typeKey);
        #endif
    }
}

#pragma clang diagnostic pop

@end