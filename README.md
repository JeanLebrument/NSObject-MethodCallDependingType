NSObject-MethodCallDependingType
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

* **"type key"**
* **"type value"**

A first NSDictionnary "methodsForRouting" contains:
* key: **"type key"**
* value: an intance of the class **"MethodsForTypeKey"**:  
                ⇒ A common name of the specific methods (prefix)  
                ⇒ An array of the different **"type value"** which exists for **"type key"** (suffix)

#### How the category parse a method name ?

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

#### 1. Construct the dic

There are two ways to use this category

#### 1. Parse the method names of its own class



#### 2. Passing an NSMutableDictonnary which contains the method names already sorted

### How to use it ?

A short paragraph to explain how to use the class.

#### 1. How to init ?  

How to init the class

#### 2. How to add in a view controller ?

How to add the instanced object in a view controller

#### 3. How to implement ?

How to implement the class  

#### 4. How to remove ?

How to remove the instanced object from the view controller

