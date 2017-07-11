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

@interface ViewController ()

@property (strong, nonatomic) RACSignal * sig;
@property (strong, nonatomic) RACDisposable * dispose;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testObserveSelector];
    //[self testDispose];
    [self testGETclass];
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
    
    [[sig subscribeNext:^(id x) {
        NSLog(@"sig will end");
    }] dispose];
    
    
    
    
    // self.sig = sig;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
