//
//  CTVSafeTool.m
//  LHChinaTV
//
//  Created by zhaoxin on 2018/5/15.
//  Copyright © 2018年 Lehoo. All rights reserved.
//

#import "CTVSafeTool.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation CTVSafeTool
+ (instancetype)sharedManager
{
    static CTVSafeTool *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[CTVSafeTool alloc] init];
    });
    return instance;
}

-(void)AppSafeDetection{
    //验证签名
    [self checkCodesign];
    /**应用完整性校验*/
    [self appIntegrityDetection];
}

/** 验证签名 */
- (void)checkCodesign {
        //获取描述文件路径
    NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:embeddedPath]) {
            // 读取application-identifier
        NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
        NSArray *embeddedProvisioningLines = [embeddedProvisioning componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        for (int i = 0; i < [embeddedProvisioningLines count]; i++) {
            if ([[embeddedProvisioningLines objectAtIndex:i] rangeOfString:@"application-identifier"].location != NSNotFound) {
                
                NSInteger fromPosition = [[embeddedProvisioningLines objectAtIndex:i+1] rangeOfString:@"<string>"].location+8;
                
                NSInteger toPosition = [[embeddedProvisioningLines objectAtIndex:i+1] rangeOfString:@"</string>"].location;
                
                NSRange range;
                range.location = fromPosition;
                range.length = toPosition - fromPosition;
                
                NSString *fullIdentifier = [[embeddedProvisioningLines objectAtIndex:i+1] substringWithRange:range];
                
                NSArray *identifierComponents = [fullIdentifier componentsSeparatedByString:@"."];
                NSString *appIdentifier = [identifierComponents firstObject];
                
                // 对比签名ID
                if (![appIdentifier isEqual:@"TUT266TGJT"]) {
//                    [self alertWithTitle:@"签名验证" message:@"签名验证失败"];
                }
                break;
            }
        }
    }
}

/**应用完整性校验*/
-(void)appIntegrityDetection{
    BOOL broken = NO;
    //1. 检查Info.plist 是否存在 SignerIdentity这个键名(Key).
    if ([[[NSBundle mainBundle] infoDictionary] objectForKey: @"SignerIdentity"] != nil) {
        broken = YES;
    }
    
    //2. 检查3个文件是否存在
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:((void)(@"%@/_CodeSignature"), bundlePath)];
    if (!fileExists) {
        broken = YES;
    }
    
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:((void)(@"%@/CodeResources"), bundlePath)];
    if (!fileExists2) {
        broken = YES;
    }
    
    BOOL fileExists3 = [[NSFileManager defaultManager] fileExistsAtPath:((void)(@"%@/ResourceRules.plist"), bundlePath)];
    if (!fileExists3) {
        broken = YES;
    }
    
    if (broken) {
        [self alertWithTitle:@"应用完整性校验" message:@"校验失败"];
    }
    
}

#pragma - mark public 提示
-(void)alertWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        exit(0);
    }];
    
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        exit(0);
    }];
    
    [alertController addAction:continueAction];
    [alertController addAction:quitAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil]
    ;
}
@end
