//
//  ViewController.m
//  reactivecocoaCodeLearn
//
//  Created by sijiechen3 on 2017/2/16.
//  Copyright © 2017年 sijiechen3. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()

@property (strong, nonatomic) RACSignal * sig;
@property (strong, nonatomic) RACDisposable * dispose;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testObserveSelector];
    //[self testDispose];
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
