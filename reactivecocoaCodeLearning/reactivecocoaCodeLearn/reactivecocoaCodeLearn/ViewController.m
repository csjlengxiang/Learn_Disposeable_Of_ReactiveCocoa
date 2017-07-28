//
//  ViewController.m
//  reactivecocoaCodeLearn
//
//  Created by sijiechen3 on 2017/2/16.
//  Copyright © 2017年 sijiechen3. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import <objc/runtime.h>

@interface FA : NSObject

@property (strong, nonatomic) NSString * kvo;

@end

@implementation FA

- (void)te {
    NSLog(@"%@ %@", self, object_getClass(self));
}

@end

@interface SO : FA

@end

@implementation SO

@end

@interface ViewController ()

@property (strong, nonatomic) RACSignal * sig;
@property (strong, nonatomic) RACDisposable * dispose;

@property (strong, nonatomic) UIButton * btn;

@property (strong, nonatomic) NSString * testStr;
@property (assign, nonatomic) int testInt;
@property (strong, nonatomic) NSObject * testObj;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testObserveSelector];
//    [self testDispose];
//    [self testGETclass];
    
//    [self testFASO];
//    [self testKVO];
//    [self testSigSig];

//    [self testSubscriberThread];

//    [self testControlEvent];
    [self testObserve];
}

- (void)testObserve {
    
    self.testStr = @"123";
    self.testObj = [[NSObject alloc] init];
    self.testInt = 1;
    
    [RACObserve(self, testStr) subscribeNext:^(id x) {
        NSLog(@"test str %@", x);
    }];
    
    [RACObserve(self, testInt) subscribeNext:^(id x) {
        NSLog(@"test int %@", x);
    }];
    
    [RACObserve(self, testObj) subscribeNext:^(id x) {
        NSLog(@"test obj %@", x);
    }];
    
    self.testStr = @"123";
    self.testObj = [[NSObject alloc] init];
    self.testInt = 1;
    
    
}

- (void)testControlEvent {
    
    self.btn = [[UIButton alloc] init];
    self.btn.frame = CGRectMake(100, 100, 200, 200);
    self.btn.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.btn];
    
    
    RACSignal * sig = [self.btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    
    [sig subscribeNext:^(id x) {
        
        NSLog(@"tap");
    }];
    
}

- (void)testSubscriberThread {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        RACSignal * originSig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@1];
                [subscriber sendCompleted];
            });
            return nil;
        }];
        
        [originSig subscribeNext:^(id x) {
            NSLog(@"%@",
                  NSThread.currentThread);
            
        }];
        
    });
    
    

    
    
}

- (void)testSigSig {
    RACSignal * originSig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"originSig didscribleBlock %@", @1);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [subscriber sendNext:@1];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal * a = [originSig map:^id(id value) {
        NSLog(@"a didscribleBlock %@", value);

        return @([value integerValue] * 2);
    }];
    
    RACSignal * b = [a map:^id(id value) {
        NSLog(@"b didscribleBlock %@", value);

        return @([value integerValue] * 2);
    }];
    
    RACSignal * c = [b map:^id(id value) {
        NSLog(@"c didscribleBlock %@", value);

        return @([value integerValue] * 2);
    }];
    
    RACSignal * sub = [c subscribeOn:[RACScheduler mainThreadScheduler]];
    
    RACSignal * d = [sub map:^id(id value) {
        NSLog(@"d didscribleBlock %@", value);

        return @([value integerValue] * 2);
    }];
    
    RACSignal * e = [d deliverOn:[RACScheduler mainThreadScheduler]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        
        [e subscribeNext:^(id x) {
            NSLog(@"d subscribe %@", x);
        }];
        
    });
    
    
}

static NSArray * ClassMethodNames(Class c)
{
    NSMutableArray * array = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++) {
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    }
    
    free(methodList);
    return array;
}

- (void)testKVO {
    
    
    FA * fa = [[FA alloc] init];
    
    NSLog(@"ClassMethodNames = %@",ClassMethodNames(object_getClass(fa)));
    NSLog(@"ClassMethodNames = %p",[fa class]);
    
    
    [fa addObserver:self forKeyPath:@"kvo" options:NSKeyValueObservingOptionNew context:nil];

    NSLog(@"ClassMethodNames = %@",ClassMethodNames(object_getClass(fa)));

    NSLog(@"ClassMethodNames = %@",ClassMethodNames([fa class]));

    NSLog(@"ClassMethodNames = %p",[fa class]);

    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
}

- (void)testFASO {
    
    FA * fa = [[FA alloc] init];
    
    [fa te];
    
    SO * so = [[SO alloc] init];
    
    [so te];
    
}

- (void)testGETclass {
    NSLog(@"vc class] %@", [self class]);
    NSLog(@"vc class %@",     object_getClass(self));
    NSLog(@"vc class class] %@",     [object_getClass(self) class]);
    NSLog(@"vc meta class %@",object_getClass(object_getClass(self)));
    NSLog(@"vc meta class class] %@",[object_getClass(object_getClass(self)) class]);
//    NSLog(@"vc meta class class] %p",[object_getClass(object_getClass(object_getClass(object_getClass(self)))) class]);

}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}

- (void)testObserveSelector {
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
    
        NSLog(@"%@", x);
    }];
    
}

- (void)testDispose {
 
    RACSignal * sig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        });
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"test disposable");
        }];
    }];
    
    [sig subscribeNext:^(id x) {
        NSLog(@"sig will end");
    }];
    
    
    
    
    // self.sig = sig;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
