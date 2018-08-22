//
//  ViewController.m
//  textLength
//
//  Created by chenpeng on 2018/6/29.
//  Copyright © 2018年 CP. All rights reserved.
//
#import "ViewController.h"

@implementation NSString (category)

- (NSInteger)getStringLenthOfBytes
{
    NSInteger length = 0;
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s]) {//检测中文或者中文符号
            NSLog(@" s 打印信息:%@",s);
            length +=2;
        }else{
            length +=1;
        }
        NSLog(@" 打印信息:%@  %ld",s,(long)length);
    }
    return length;
}

- (NSString *)subBytesOfstringToIndex:(NSInteger)index
{
    NSInteger length = 0;
    
    NSInteger chineseNum = 0;
    NSInteger zifuNum = 0;
    
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s])//检测中文或者中文符号
        {
            if (length + 2 > index)//长度超出返回前面的字符串
            {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            
            length +=2;//进行的位数（中文两位）
            
            chineseNum +=1;//进行到某一字符
        }
        else
        {
            if (length +1 >index)
            {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            length+=1;
            
            zifuNum +=1;
        }
    }
    return [self substringToIndex:index];
}

//检测中文或者中文符号
- (BOOL)validateChineseChar:(NSString *)string
{
    NSString *nameRegEx = @"[\\u0391-\\uFFE5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

//检测中文
- (BOOL)validateChinese:(NSString*)string
{
    NSString *nameRegEx = @"[\u4e00-\u9fa5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

- (BOOL)isMatchesRegularExp:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


@end


@interface ViewController ()


@end

@implementation ViewController{
    int kMaxNumber;// 最大位数（中文一个字符两位，英文一个字符一位）
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    kMaxNumber = 10;
    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 250, 50)];
    field.layer.borderWidth = 2;
    field.layer.borderColor = [UIColor blueColor].CGColor;
    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:field];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (kMaxNumber == 0) return;
    
    NSString *toBeString = textField.text;
    
    NSLog(@" 打印信息toBeString:%@",toBeString);
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        //判断markedTextRange是不是为Nil，如果为Nil的话就说明你现在没有未选中的字符,可以计算文字长度。否则此时计算出来的字符长度可能不正确。
        UITextRange *selectedRange = [textField markedTextRange];
        
//      光标位置的获取
//      在textField中，有一个属性称之为selectedTextRange，这个属性为UITextRange类型，包含[start,end)两个值，通过实验我们可以发现，在没有文字被选取时，start代表当前光标的位置，而end＝0；当有区域被选择时，start和end分别是选择的头和尾的光标位置，从0开始，并且不包含end，例如选择了0～3的位置，则start＝0，end＝4。
        
//      光标的移动
//      通过setSelectedTextRange:方法可以设置选取范围，我们只要设置一个选取单个字符的范围，即可移动光标而不选中。
        
        //获取高亮部分(输入中文 的时候才有)
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];//从另一个文本位置返回给定偏移量处的文本位置。一个自定义UITextPosition对象，它表示文档中与位置之间的指定偏移量。如果计算的文本位置小于0或大于后置字符串的长度，则返回nil。
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            //中文和字符一起检测  （中文两个字符）
            if ([toBeString getStringLenthOfBytes] > kMaxNumber)
            {
                textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
                
            }
        }
    }
    else
    {
        if ([toBeString getStringLenthOfBytes] > kMaxNumber)
        {
            textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
