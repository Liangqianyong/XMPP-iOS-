//
//  RosterTableViewController.m
//  XMPP
//
//  Created by 梁前勇 on 2017/3/20.
//  Copyright © 2017年 梁前勇. All rights reserved.
//

#import "RosterTableViewController.h"
#import "XMPPManager.h"
#import "ChatTableViewController.h"
@interface RosterTableViewController ()<XMPPRosterDelegate,UIAlertViewDelegate>

//数据源
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation RosterTableViewController
- (IBAction)addFriend:(id)sender {
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        UITextView * textFiled=[alertView textFieldAtIndex:0];
        XMPPJID * jid=[XMPPJID jidWithUser:textFiled.text domain:kDomin resource:kResourse];
        [[XMPPManager shareManager].xmppRoster addUser:jid withNickname:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[XMPPManager shareManager].xmppStream.myJID.user;
    self.dataArray =[NSMutableArray array];
    //设置代理
    [[XMPPManager shareManager].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    }

//开始检索好友
-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    NSLog(@"开始检索好友");
}
//检索到好友
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    //获取Jid字符串
    NSString * jidstr=[[item attributeForName:@"jid"]stringValue];
    //创建Jid对象
    XMPPJID * jid=[XMPPJID jidWithString:jidstr];
    //加入数组中
    if ([self.dataArray containsObject:jid]) {
        return;
    }
    [self.dataArray addObject:jid];
    
    NSIndexPath * indexpath=[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
//检索结束
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    NSLog(@"检索结束");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    XMPPJID * jid=self.dataArray[indexPath.row];
    cell.textLabel.text=jid.user;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   //通过segue取到聊天页面控制器
    ChatTableViewController * chatVC =segue.destinationViewController;
    //取到cell
    UITableViewCell * cell =sender;
    
    //找到indexpath
    NSIndexPath * indexPath=[self.tableView indexPathForCell:cell];
    XMPPJID * jid=self.dataArray[indexPath.row];
    chatVC.friendJID=jid;
    
    
    
    
}


@end
