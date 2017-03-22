//
//  LoginViewController.m
//  XMPP
//
//  Created by 梁前勇 on 2017/3/17.
//  Copyright © 2017年 梁前勇. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPManager.h"
@interface LoginViewController ()<XMPPStreamDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理
    [[XMPPManager shareManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (IBAction)LoginBtn:(id)sender {
    [[XMPPManager shareManager] loginWithUserName:self.userName.text passWord:self.passWord.text];
}
- (IBAction)ReginBtn:(id)sender {
    
}
//验证成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"登录成功");
    XMPPPresence * Presence = [XMPPPresence presenceWithType:@"available"];
    [[XMPPManager shareManager].xmppStream sendElement:Presence];
    
    //登录成功进入好友列表
    [self performSegueWithIdentifier:@"roster" sender:nil];
}
//登录失败的方法
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"登录失败");
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
