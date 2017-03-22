//
//  XMPPManager.m
//  XMPP
//
//  Created by 梁前勇 on 2017/3/17.
//  Copyright © 2017年 梁前勇. All rights reserved.
//

#import "XMPPManager.h"
@interface XMPPManager ()<UIAlertViewDelegate>

typedef NS_ENUM(NSInteger,ConnectToServerPurpose)
{
    ConnectToServerPurposeLogin,
    ConnectToServerPurposeRegister
};
@property(nonatomic,copy) NSString * passWord;

@property(nonatomic,assign)ConnectToServerPurpose  connectToServerPurpose;

@property(nonatomic,strong)XMPPJID * fromJID;
@end
@implementation XMPPManager

//创建单例
+(XMPPManager*)shareManager
{
    static XMPPManager * manager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc]init];
        
    });
    return manager;
}
//初始化方法
-(instancetype)init
{
    if (self=[super init]) {
        //设置通信通道对象
        self.xmppStream =[[XMPPStream alloc]init];
        //设置服务器IP地址
        self.xmppStream.hostName=kHostName;
        //设置服务器端口
        self.xmppStream.hostPort=kHostPort;
//        ..设置代理
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        //花名册数据存储对象
        XMPPRosterCoreDataStorage * rosterStorage=[XMPPRosterCoreDataStorage sharedInstance];
        //创建花名册管理对象
        self.xmppRoster =[[XMPPRoster alloc]initWithRosterStorage:rosterStorage dispatchQueue:dispatch_get_main_queue()];
        //激活通道对象
        [self.xmppRoster activate:self.xmppStream];
        
        //设置代理
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        //创建信息归档数据存储对象
        XMPPMessageArchivingCoreDataStorage * messageArchivingCoreDataSotorage=[XMPPMessageArchivingCoreDataStorage sharedInstance];
        //创建信息归档对象
        self.xmppMessageArchiving =[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:messageArchivingCoreDataSotorage dispatchQueue:dispatch_get_main_queue()];
        //激活通信通道
        [self.xmppMessageArchiving activate:self.xmppStream];
        //创建数据管理器
        self.context=messageArchivingCoreDataSotorage.mainThreadManagedObjectContext;
        
    }
    return self;

    
}
//登录
-(void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord

{
    self.passWord =passWord;
    self.connectToServerPurpose=ConnectToServerPurposeLogin;
    [self connectToServerWithUserName:userName];
    
}
//注册
-(void)registerWithUserName:(NSString *)userName passWord:(NSString *)passWord
{
    self.connectToServerPurpose=ConnectToServerPurposeRegister;
    self.passWord=passWord;
    [self connectToServerWithUserName:userName];
}
//链接服务器
-(void)connectToServerWithUserName:(NSString *)userName
{
    //创建XMPPJID对象
    XMPPJID * jid=[XMPPJID jidWithUser:userName domain:kDomin resource:kResourse];
    //设置通信通道对象的jid
    self.xmppStream.myJID=jid;
    
    //发送请求  先判断是否在线
    if ([self.xmppStream isConnected]||[self.xmppStream isConnecting]) {
        //先发送下线状态
        XMPPPresence * presence =[XMPPPresence presenceWithType:@"unavailable"];
        [self.xmppStream sendElement:presence];
        
        //断开连接
        [self.xmppStream disconnect];
    }
    //重新发送登录请求
    NSError * error=nil;
    //设置为-1就是代表没有请求超时
    [self.xmppStream connectWithTimeout:-1 error:&error];
    if (error !=nil) {
        NSLog(@"链接失败,失败原因：%@",[error localizedDescription]);
    }
    
    
    
}
//连接超时的方法
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"连接服务器超时");
}
//链接成功的代理方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    
    switch (self.connectToServerPurpose) {
        case ConnectToServerPurposeLogin:
            //验证登录密码
            [self.xmppStream authenticateWithPassword:self.passWord error:nil];
            break;
         case ConnectToServerPurposeRegister:
            //验证注册登录密码
            [self.xmppStream registerWithPassword:self.passWord error:nil];
            break;
        default:
            break;
    }
    
    
    
    
}
//收到好友请求的方法
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    self.fromJID=presence.from;
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"好友申请" message:presence.from.user delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
                             
    [alertView show];
    
                             
                             
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //就拒绝添加好友
            [self.xmppRoster rejectPresenceSubscriptionRequestFrom:self.fromJID];
            break;
            case 1:
            //同意添加好友
            [self.xmppRoster acceptPresenceSubscriptionRequestFrom:self.fromJID andAddToRoster:YES];
        default:
            break;
    }
}





@end
