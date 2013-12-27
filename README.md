Category NSObject+MethodCallDependingType
================================

### Summary

This category permits to route method for a specific using depending a type.

It goal is to avoid "switch case" or consecutive "if / else if / else" to call a specific method depending on the value of an enum or a #define.

The category store the method names of each method of the class which respects a specified "protocol".

#### Exemple

Depending on defines you have to call different methods with a very similar goal.

```objectivec
#define kiOSVersion @"KIOSVersion"

#define kIOS6 @"KIOS6"
#define kIOS7 @"KIOS7"

```

Without use this category you should do this way:

```objectivec
...
- (void)viewDidLoad
{
    if ([self.myIOSVersion isEqualToString:kIOS6])
        [self createMenuForiOS6WithTitle:self.menuTitle];
    else if ([self.myIOSVersion isEqualToString:kIOS7])
        [self createMenuForiOS7WithTitle:self.menuTitle];
}
...
```

With the category:

```objectivec

#import "NSObject+MethodCallDependingType.h"

- (void)viewDidLoad
{
    // Parse the name of each methods wich contains the string @"KIOSVersion" and store them
    [test constructMethodsListForRouting:@[kiOSVersion] FromClass:[self class]];
    
    [test callRoutedMethod:@"createMenu" withTypeKey:kiOSVersion andTypeValue:kIOS6 andParameters:self.menuTitle];
}

- (void)createMenuDependingOnKIOSVersionKIOS6:(NSString *)title
{
    // do stuff
}

- (void)createMenuDependingOnKeyIOSVersionKIOS6:(NSString *)title
{
    // do stuff
}
```

### How does it work ?

The method names are stored and sorted depending on two types.

* **"type key"** _(could be interpreted like the type of an Enum)_
* **"type value"** _(could be interpreted like a field of an Enum)_

A first NSDictionnary "methodsForRouting" contains:
* key: **"type key"**
* value: an intance of the class **"MethodsForTypeKey"**:  
                ⇒ A common name of the specific methods (prefix)  
                ⇒ An array of the different **"type value"** which exists for **"type key"** (suffix)

#### Why use a **"type key"** and a **"type value"** ?

* Optimiszed by limiting the number of loop iteration to find a desired method.
* Use the same **"type value"** but for a different **"type key"**.

#### How the category parses a method name ?

To be parsed a method name must respect the following nomenclature:

1. An identical prefix for all the specifics method:  
    ⇒ Ex: createMenu
2. A string which define the protocol: (Default is "DependingOn" but can be modified with the protocol setter from the category)  
    ⇒ Ex: DependingOn
3. A **"type key"**  
    ⇒ Ex: KIOSVersion
4. A **"type value"**  
    ⇒ Ex: KIOS6

Result:

```objectivec
- (void)createMenuDependingOnKIOSVersionKIOS6;

// OR

- (void)createMenuDependingOnKIOSVersionKIOS6:(Whatever *)params;
```


### How to use it ?

##### Two ways to init the category:

######      ⇒ First: The category parses the method names 
You don't have to parse the method names, the category do this for you by using this method:

```objectivec
/*
 ** @parameter: typeList - Array containing the different types of key that the user need to route his methods.
 ** @parameter: className - The class to get the method names.
 ** Store the class methods name which contains a type from the "typesList" given in paramter
 */
- (void)constructMethodsListForRouting:(NSArray *)typesList FromClass:(Class)className;
```
######      ⇒ Second: Set a Dictionnary with the method names already parsed

Be carreful, you can set your own dictionnary parsed with method names. But if the dictionnary doesn't respect the architecture the category will no longer work.

```objectivec
- (void)setMethodsForRouting:(NSDictionary *)dictionnary
```

##### Protocol

String wich permits to identify if a method name need to be parsed.

By default the string "protocol" value is **"DependingOn"** but you can set another protocol value by using this setter:

```objectivec
- (void)setProtocol:(NSString *)protocol
```
