clear

path=`pwd`

keys=(render trade-base service trade-hfb system xf manage member base www api ypz trade-hfd hkagent paycenter steward hgj resource permission bis esf zf gold event static)
gits=(app-render app-trade-base app-service app-trade-hfb system app-hf-xf app-hf-manage app-hf-member app-hf-base app-hf-www app-hf-api app-hf-ypz app-trade-hfd app-hf-hkagent app-hf-paycenter app-hf-steward app-hf-hgj app-hf-resource app-hf-permission app-hf-bis app-hf-esf app-hf-zf app-hf-gold app-hf-event hf-static)
cmds=(gl gc gf gs gv go gpl gph gb)

#git日志
gl="git log --graph --pretty=format:%Cred%h%Creset-%an,%ar:%s --abbrev-commit"

#清除未跟踪的文件
gc='git clean -df'

#比较最近两次提交的差异
gf='git diff'

#撤销未提交的修改
gr='git reset --hard'

#查看当前版本库的状态
gs='git status'

#查看remote列表
gv='git remote -v'

#更新pull
gpl='git pull --rebase origin'

#更新pull
gph='git push --progress origin'

#切换分支
go='git checkout'

#查看版本
gb='git branch'

function get_git()
{
	key=$1
	a_len=${#keys[@]}
	for((i=0;i<a_len;i++))
	do
		if [ "${keys[$i]}" == "$key" ]; then
			echo ${gits[$i]}
			return 0
		fi
	done
	echo null
}

function get_cmd()
{
	key=$1
	a_len=${#cmds[@]}
	for((i=0;i<a_len;i++))
	do
		if [ "${cmds[$i]}" == "$key" ]; then
			echo 1
			return 0
		fi
	done
	echo 0
}

function run_action()
{
	tmp=(echo $1)
	cmd=${tmp[1]}
	a_len=${#tmp[@]}
	args=""
	for((i=2;i<a_len;i++))
	do
		if [ "$args" == "" ]; then
			args=${tmp[$i]}
		else
			args="$args ${tmp[$i]}"
		fi
	done
	
	has=`get_cmd $cmd`
	if [ "$has" == "1" ]; then
		run_all "$cmd" "$args"
	elif [ "$cmd" != "" ]; then
		`${tmp[*]}`
	fi
}

function run_all()
{
	cmd=$1
	args=$2
	if [ "$cmd" == "go" -o "$args" == "all" -o "$args" == "" ]; then
		cd $path		
		if [ "$cmd" == "go" ]; then
			scmd="${!cmd} $args"
		else
			scmd="${!cmd}"
		fi
		for f in `ls`
		do
			f=$path/$f
			if [ -d $f ]; then
				cd $f
				if [ "$cmd" == "gb" ]; then
					echo -n -e "\033[32m $scmd $f \033[0m"
					$scmd|grep "\*"
				else
					echo -e "\033[32m $scmd $f \033[0m"
					$scmd
					echo ""
				fi
			fi
		done
	else
		args=(`echo $args`)
		for f in ${args[*]}
		do
			rs=`get_git $f`
			if [ -d "$path/$rs" ]; then
				cd $path/$rs
				${!cmd}
			else
				echo "$f not found"
			fi
		done
	fi
}

while [ 1 ]
do
	read -p "git> " cmd
	run_action "$cmd"
done
