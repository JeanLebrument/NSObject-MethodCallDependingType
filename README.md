NSObject-MethodCallDependingType
================================

### Summary

This category permits to route method for a specific using depending a type

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
- (void)viewDidLoad
{
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

