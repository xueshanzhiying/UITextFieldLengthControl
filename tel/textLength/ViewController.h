//
//  ViewController.h
//  textLength
//
//  Created by chenpeng on 2018/6/29.
//  Copyright © 2018年 CP. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (category)

- (NSInteger)getStringLenthOfBytes;

- (NSString *)subBytesOfstringToIndex:(NSInteger)index;

@end



#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@end

