// -*- mode:objc -*-
//
// Copyright (c) 2013 MIYOKAWA, Nobuyoshi (http://www.tempus.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import "ViewController.h"

#import "AppDelegate.h"

@interface ViewController ()
@property (nonatomic) NSInteger count;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  UIApplication *application = [UIApplication sharedApplication];
  AppDelegate *appDelegate = application.delegate;
  NSLog(@"invoke beginBackgroundTaskWithExpirationHandler:");
  appDelegate.bgTask =
    [application beginBackgroundTaskWithExpirationHandler:^{
      [application endBackgroundTask:appDelegate.bgTask];
      appDelegate.bgTask = UIBackgroundTaskInvalid;
    }];

  dispatch_async(
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      while (1) {
        if (application.backgroundTimeRemaining >= 600) {
          NSLog(@"foreground");
        } else {
          NSLog(@"%f", application.backgroundTimeRemaining);
        }
        application.applicationIconBadgeNumber = self.count++;
        sleep(1);
      }
    });
}

- (IBAction)changeStateOnSwitch:(UISwitch *)sender
{
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  appDelegate.clearAtDidBecomeActive = sender.on;
}

@end

// EOF
