#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
############################################################
# Filename: autoproxy.py
# Author: aqshing
# Email: jdbc.cc <work@jdbc.cc>
# Brief: pip -m geoip2 tld
# Created: 2024-07-01 18:38:19
# Changed: 2024-08-04 01:34:50
############################################################
import subprocess
import ast
import sys
import traceback
import datetime
import os
import re
import socket
from urllib.parse import urlparse

def try_install_and_import(package, import_name=None):
    if import_name is None: import_name = package
    try:
        __import__(import_name)
    except ImportError:
        print(f"{package} not found. Installing...")
        print(f"run cmd: {sys.executable} -m pip install {package}")
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', package])
        __import__(import_name)

def custom_exception_handler(exctype, value, tb):
    if exctype == ModuleNotFoundError:
        package_name = value.name.split('.')[0]  # 获取包的顶级名称
        print(f"Module {package_name} not found. Attempting to install and import...")
        try:
            try_install_and_import(package_name)
            # # 获取最后一个引发异常的帧
            # last_frame = traceback.extract_tb(tb)[-1]
            # # 获取出错的行
            # code_line = last_frame.line
            # # 执行出错的行
            # if code_line:
            #     print(f"Re-executing: {code_line}")
            #     exec(code_line, globals())
            # 获取当前脚本的路径
            script_path = os.path.abspath(sys.argv[0])

            # 使用execv重新执行当前脚本
            print(f"Re-executing script {script_path} after installing {package_name}")
            os.execv(sys.executable, [sys.executable] + sys.argv)
        except Exception as e:
            print(f"Failed to install and import {package_name}. Error: {e}")
    else: # For other exceptions, use the default handler
        sys.__excepthook__(exctype, value, tb)

def parse_imports(filename):
    """解析python源文件import了哪些库"""
    with open(filename, "r", encoding="utf-8") as f:
        tree = ast.parse(f.read())

    imports = set()

    class ImportVisitor(ast.NodeVisitor):
        def visit_Import(self, node):
            for alias in node.names:
                imports.add(alias.name.split(".")[0])
            self.generic_visit(node)

        def visit_ImportFrom(self, node):
            module_name = node.module.split(".")[0] if node.module else ""
            for alias in node.names:
                imports.add(module_name + "." + alias.name.split(".")[0])
            self.generic_visit(node)

    visitor = ImportVisitor()
    visitor.visit(tree)

    return list(imports)

# print(parse_imports(sys.argv[0]))
# 拦截全局异常
sys.excepthook = custom_exception_handler

import geoip2.database
import requests
from tld import get_tld

# geoip_database_file = 'GeoLite2-Country.mmdb'
geoip_database_file = 'GeoLite2-City.mmdb'
loglevel = 'info'

# 自动启用或关闭输出颜色
# 'SHELL' ('bash', 'zsh') bash zsh else none
# 'COMSPEC' ('cmd.exe') Windows
# 'PROMPT' ('$P$G') wincmd else none
# 'PSModulePath' (os.pathsep) PowerShell wincmd exe else none
#    0    1     2         3          4
# [bash, zsh, wincmd, powershell, desktop, windows]
def getparent(env: str):
    sh = os.getenv(env)

    if sh:
        if env == 'PSModulePath':
            return len(os.getenv('PSModulePath', '').split(os.pathsep)) >= 3
        for s in ('bash', 'zsh', 'cmd.exe', '$P$G'):
            if s in sh: return True
    return False


nocolor = not getparent('SHELL')  # if 父进程是bash或zsh, 则开启颜色高亮
colors = {"debug", "info", "warn", "error"}
# Blue Green Yellow Red
colors_number = [34, 32, 33, 31]
for i, color in enumerate(colors):

loglevelout = colors.get(loglevel, 2)[1]
if nocolor: Print = lambda outmsg, color=0, flush = False: print(outmsg, flush=flush)
else: Print = lambda outmsg, color=0, flush = False: print(f"\033[{color}m" + str(outmsg) + "\033[0m", flush=flush)

def MyLog(msg:str , level: str):
    #outlevel = colors.get(level, 0)[1]
    # 根据传进来的字符串,取出其对应的索引值和颜色值
    # 请补充此部分代码
    # if outlevel >= loglevelout:
    if outlevel == loglevelout:
        Print(f"[{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] [{level}] {msg}", colors.get(level, 0)[0], flush=True)

Debug = lambda msg: MyLog(msg, "debug")
Info = lambda msg: MyLog(msg, "info")
Warn = lambda msg: MyLog(msg, "warn")
Error = lambda msg: MyLog(msg, "error")

def get_domain(url):
    try:
        domain = get_tld(url, as_object=True, fix_protocol=True, fail_silently=True)
    except Exception as e:
        Error(e)
        domain = None

    # 判断是否成功
    if domain is not None:
        # 输出url中的域名
        domain = domain.parsed_url.netloc
    else:
        # 如果 URL 没有以 http:// 或 https:// 开头，则添加 http://
        # if not url.startswith(('http://', 'https://')):
        # 正则表达式检测是否以 *:// 开头
        if not re.match(r'^[a-zA-Z][a-zA-Z0-9+.-]*://', url):
            url = 'http://' + url
        try: # 输出url中的ip
            domain = urlparse(url).netloc
            # 如果有端口号, 过滤掉端口号
            domain = re.sub(r':\d+$', '', domain)
        except Exception as e:
            Error(e)
            domain = None
    return domain


# @brief: 使用geoiplookup判断是否是大陆IP
def is_web_in_cn(netloc):
    """使用 MaxMind GeoIP2 查询 IP 地址或域名是否属于中国大陆"""
    try:
        # 打开 GeoIP 数据库文件
        with geoip2.database.Reader(geoip_database_file) as reader:
            # 如果输入是域名 解析域名并返回其 IP 地址
            if not netloc.replace('.', '').isdigit():
                try:
                    ip_address = socket.gethostbyname(netloc)
                except socket.error as e:
                    raise ValueError(f"Cannot resolve IP address for hostname: {netloc} {e}")

            # address = reader.country(ip_address)
            address = reader.city(ip_address)

            # 判断国家是否为中国
            Info(f"{netloc} from {address.country.name} {address.city.name if address.city.name else ''}")
            # print(f"{netloc} from {address.country.name} {address.city.names.get('zh-CN') if address.city.name else ''}")
            if address.country.iso_code != 'CN':
                return False
    except Exception as e:
        Error(f"Error querying GeoIP database: {e}")
    # 其余情况都认为不应该开启vpn
    return True

def download_database():
    import base64
    import io
    import tarfile

    # Account_ID = os.getenv('MaxMind_Account_ID')
    license_key = os.getenv('MaxMind_License_key')
    # 检查是否设置了 MaxMind_Account_ID 和 MaxMind_License_key
    if license_key is None:
        Info("Please set the MaxMind_License_key environment variable to the base64 encoded license key:")
        Info("example: echo 'your_license_key' | base64")
        Info("export MaxMind_License_key='after_base64_license_key'")
        # print("export MaxMind_Account_ID=your_account_id")
        return
    # 进行 Base64 解码
    License_key = base64.b64decode(license_key).decode('utf-8')
    URL = f'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&suffix=tar.gz&license_key={License_key}'

    # 下载数据库文件
    response = requests.get(URL, stream=True)
    response.raise_for_status()  # 检查请求是否成功

    # 使用 io.BytesIO 在内存中解压文件
    file_like_object = io.BytesIO(response.content)
    with tarfile.open(fileobj=file_like_object, mode='r:gz') as tar:
        for member in tar.getmembers():
            # 查找 mmdb 文件
            if member.name.endswith('.mmdb'):
                member_file = tar.extractfile(member)
                # 写文件
                if member_file is not None:
                    with open(geoip_database_file, 'wb') as f:
                        f.write(member_file.read())
                        Info(f"Downloaded {geoip_database_file}")

def updatedatabase():
    from tld.utils import update_tld_names
    update_tld_names()
    download_database()

def main(args: list[str]):
    if not bool(args):
        Warn("usage: python3 {0} [...]".format(sys.argv[0]))
        return 0

    # 变更工作目录到当前脚本所在路径
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    Debug(f"Current working directory: {os.getcwd()}")

    if not os.path.exists(geoip_database_file):
        Warn(f"{geoip_database_file} does not exist. Downloading and extracting the database.")
        updatedatabase()

    isOpenVPN = []
    for url in args:
        # 如果url以 - 开头是参数, 则跳过
        if url.startswith('-'):
            continue
        netloc = get_domain(url)
        if netloc is not None:
            isOpenVPN.append(is_web_in_cn(netloc))

    Debug(isOpenVPN)
    if not all(isOpenVPN): Info("use proxy...")
    return all(isOpenVPN)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

# from tld import is_tld
# if is_tld(string): 检查是否是个合法的顶级域名后缀

# def get_domain(url):
#     return get_tld(url, as_object=True, fix_protocol=True, fail_silently=True)
#     result = get_tld(url, as_object=True, fix_protocol=True, fail_silently=True)
#     "http://tw.weather.yahoo.com/helmfile/helmfile/releases/download/v0.166.0/helmfile_0.166.0_linux_amd64.tar.gz"
#     "news.ttv.com.tw/helmfile/helmfile/releases/download/v0.166.0/helmfile_0.166.0_linux_amd64.tar.gz"
#     不带后缀的顶级域名
#     print(result.domain) # yahoo; ttv
#     带后者顶级域名 domain with suffix
#     print(result.fld) # yahoo.com; ttv.com.tw
#     子域名部分
#     print(result.subdomain) # tw.weather; news
#     包含子域名的全部域名
#     print(result.parsed_url.netloc) # tw.weather.yahoo.com; news.ttv.com.tw
# def parse_imports(filename):
#     """解析python源文件import了哪些库"""
#     with open(filename, "r", encoding="utf-8") as f:
#         tree = ast.parse(f.read())
#     imports = set()
#     for node in ast.iter_child_nodes(tree):
#         if isinstance(node, ast.Import):
#             for alias in node.names:
#                 imports.add(alias.name.split(".")[0])
#         elif isinstance(node, ast.ImportFrom):
#             module_name = node.module.split(".")[0] if node.module else ""
#             for alias in node.names:
#                 imports.add(module_name + "." + alias.name.split(".")[0])

#     return list(imports)