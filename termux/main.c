/* motto: We don't produce code, we're just GitHub porters!
 * ============================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  守护进程
 *
 *        Version:  1.0
 *        Created:  Sun Jun 27 23:58:30 2021
 *        Changed:  2021-09-10 12:23:50
 *       Compiler:  GCC
 *
 *         Author:  shing www.asm.best
 *          Email:
 *   Organization:
 *
 *        License:  The GPL License
 *      CopyRight:  See Copyright Notice in LICENSE.
 *
 * ============================================================================
 */
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

int KernelCode(const char* argv[]) {
    int ret = 0;
    char nowtime[64] = {0};
    time_t rawtime;

    //将strout stderr重定向到日志文件中
    if (!freopen(".logd", "wb+", stdout) || !freopen(".errd", "wb+", stderr)) {
        perror(strerror(errno));
        ret = -6;
        goto fclabel;
    }

    printf("child pid:%d\n", getpid());
    fflush(stdout);
    //判断daemon命令是否为null
    if (argv[1]) {  //执行daemon命令
        // execvp(daemon命令，daemon命令参数)；
        ret = execvp(argv[1], (char* const*)&argv[1]);
        time(&rawtime);
        strftime(nowtime, sizeof(nowtime) / sizeof(char), "%y-%m-%d %H:%M:%S",
                 localtime(&rawtime));
        fprintf(stderr, "%s: ", nowtime);
        for (size_t i = 1; argv[i] != NULL; ++i) {
            fprintf(stderr, "%s ", argv[i]);
        }
        fprintf(stderr, "error!\n");
    }

fclabel:
    // close C STDIO
    fclose(stdin);
    fclose(stdout);
    fclose(stderr);

    return ret;
}

int Daemon(const char* argv[]) {
    //创建子进程，父进程退出
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork error!");
        return -1;
    }

    if (pid > 0) {
        // printf("ppid:%d, father exit!\n", getppid());
        return 0;
    }

    //开启一个会话，将子进程与shell分离，此时子进程是会话组组长
    if (setsid() < 0) {
        perror("setsid error!");
        return -2;
    }

    //第二次fork, 此时的子进程不可能是会话组组长，也就不可能再次打开终端
    pid = fork();
    //父进程退出
    if (pid != 0) {
        // printf("ppid:%d, father quit!\n", getppid());
        return 0;
    }

    //设置掩码
    umask(0);

    //切换工作目录
    if (chdir(getenv("HOME")) < 0) {
        perror("mkdir error");
        return -4;
    }

    //忽略SIGCHLD信号
    signal(SIGINT, SIG_IGN);
    signal(SIGQUIT, SIG_IGN);
    if (signal(SIGCHLD, SIG_IGN) == SIG_ERR) {
        perror("signal error!");
        return -5;
    }

    //关闭标准输入输出文件描述符
    close(0); /* Standard input.  */
    close(1); /* Standard output.  */
    close(2); /* Standard error output.  */

    //执行核心逻辑
    // system("make  >nohup.out 2>&1");
    return KernelCode(argv);
}

int main(int argc, const char* argv[]) { return Daemon(argv); }
