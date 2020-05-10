#include "PaiguRootListController.h"
#include <spawn.h>

//system函数执行命令的替换方法
extern char **environ;
void run_cmd(char *cmd)
{
	pid_t pid;
	char *argv[] = {"sh", "-c", cmd, NULL};
	int status;

	status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
	if (status == 0)
	{
		if (waitpid(pid, &status, 0) == -1)
		{
			perror("waitpid");
		}
	}
}

@implementation PaiguRootListController

- (NSArray *)specifiers
{
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)donateViaAlipay
{
	[[UIApplication sharedApplication] openURL:
		[NSURL URLWithString:@"https://qr.alipay.com/fkx11847cc72d5vzsopdv56"]
		options:@{}
		completionHandler:nil];
}

- (void)killexec
{
	run_cmd("killall -9 NewsSocial");
	run_cmd("killall -9 News");
}

- (void)myrepo
{
	[[UIApplication sharedApplication] openURL:
		[NSURL URLWithString:@"https://wstclzy2010.github.io/repo/"]
		options:@{}
		completionHandler:nil];
}

- (void)opensource
{
	[[UIApplication sharedApplication] openURL:
		[NSURL URLWithString:@"https://github.com/wstclzy2010/PureNewSocial"]
		options:@{}
		completionHandler:nil];
}
	
@end
