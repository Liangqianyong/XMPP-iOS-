//
//  RegisterViewController.m
//  XMPP
//
//  Created by 梁前勇 on 2017/3/20.
//  Copyright © 2017年 梁前勇. All rights reserved.
//

#import "RegisterViewController.h"
#import "XMPPManager.h"
@interface RegisterViewController ()<XMPPStreamDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理
    [[XMPPManager shareManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    [self.navigationController popViewControllerAnimated:YES];
}
//注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
}
- (IBAction)RegisterBtn:(id)sender {
    [[XMPPManager shareManager]registerWithUserName:self.userName.text passWord:self.passWord.text];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
