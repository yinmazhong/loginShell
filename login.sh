#!/bin/bash

# Function : 自动登录
# Author   : 徐半仙
# Date     : 2017/10/20

#默认服务器配置项
#    "服务器名称 端口号 IP地址 登录用户名 登录密码"
CONFIGS=(
)

#读取自定义服务器配置文件（server_config）列表，合并服务器配置列表
if [ -f server_config ]; then
	while read line
	do
		CONFIGS+=("$line")
	done < server_config
fi

#服务器配置数
CONFIG_LENGTH=${#CONFIGS[*]}  #配置站点个数

if [[ $CONFIG_LENGTH -le 0 ]] ;
then
    echo "未检测到服务器配置项!"
    echo "请在脚本CONFIGS变量中配置或单独创建一个server_config文件并配置"
    exit ;
fi

#服务器配置菜单
function ConfigList(){
    for ((i=0;i<${CONFIG_LENGTH};i++));  
    do  
        CONFIG=(${CONFIGS[$i]}) #将一维sites字符串赋值到数组  
        serverNum=$(($i+1)) 
        echo "---(${serverNum})--${CONFIG[0]}(${CONFIG[2]})---"
    done 
}

#登录菜单
function LoginMenu(){
    if [  ! -n $1 ]; then
        AutoLogin $1
    else
        echo "-------请输入登录的服务器序号---------"
        ConfigList
        echo "请输入您选择登录的服务器序号: "
    fi
}

#选择登录的服务器
function ChooseServer(){
    read serverNum
    if [[ $serverNum -gt $CONFIG_LENGTH ]] ;
    then
        echo "输入的序号不正确，请重新输入:"
        ChooseServer ;
        return ;
    fi
    if [[ $serverNum -lt 1 ]] ;
    then
        echo "输入的序号不正确，请重新输入:"
        ChooseServer ;
        return ;
    fi
 
    AutoLogin $serverNum;
}  

#自动登录
function AutoLogin(){
    
    num=$(($1-1)) 
    CONFIG=(${CONFIGS[$num]})  
    echo "正在登录【${CONFIG[0]}】"
    ${CONFIG[1]} ${CONFIG[2]} ${CONFIG[3]} ${CONFIG[4]}
    echo "您已退出【${CONFIG[0]}】"
    
}

# 程序入口
#　检测脚本执行时带的参数数量
if [ 1 == $# ]; then
    if [ 'list' == $1 ]; then
        ConfigList
    else
        AutoLogin $1
    fi
else
    LoginMenu 
    ChooseServer 
fi

