//
//  NSObject+MethodCallDependingType.h
//
//  Created by Jean Lebrument on 12/27/13.
//  Github: JeanLebrument
//

#import <Foundation/Foundation.h>

@interface MethodsForTypeKey : NSObject

@property (nonatomic, strong) NSString *methodNameForRouting;
@property (nonatomic, strong) NSMutableArray *specificsMethodsName;

@end

@interface NSObject (RouterMethodsDependingOnType)

/*
 ** "Protocol" permits to find a method of the desired class in the dictionnary methodsForRouting
 */
@property (nonatomic, copy) NSString *protocol;

/*
 ** Dictionary wich contains for key the key type and for value an instance of the class "MethodsForTypeKey" with
 ** inside the begining of the method name before the "protocol" and an array of the type value as suffixes
 */
@property (nonatomic, copy) NSMutableDictionary *methodsForRouting;

/*
 ** @parameter: typeList - Array containing the different types of key that the user need to route his methods.
 ** @parameter: className - The class to get the method names.
 ** Store the class methods name which contains a type from the "typesList" given in paramter
 */
- (void)constructMethodsListForRouting:(NSArray *)typesList FromClass:(Class)className;

/*
 ** @parameter: methodNameForRoute - the begining of the method name before the "protocol" string
 ** @parameter: typeKey - The key type
 ** @parameter: typeValue - the value type
 ** @parameter: params - Parameter(s) to send through the selector
 ** Find the specific method thanks to the parameter and call it through performSelector.
 */
- (void)callRoutedMethod:(NSString *)methodNameForRoute withTypeKey:(NSString *)typeKey andTypeValue:(NSString *)typeValue andParameters:(id)params;

@end