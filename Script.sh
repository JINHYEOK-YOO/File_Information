#!/bin/bash

mypos=`pwd`	#실행위치 저장
space=''	#트리구조 공백

file_info()
{
	num=1

	for file in `ls -l | grep '^d' | awk '{print $9}' ; ls -l | grep '^-' | awk '{print $9}' ; ls -l | grep -v '^d' | grep -v '^-' | awk '{print $9}'`
	#ls -l 명령어 결과에서 디렉토리, 일반파일, 나머지 순으로 파일 이름만 추출 후 file에 차례로 대입
	do
		echo "${space}[${num}] `stat -c %n $file`"
		echo "${space}-----------------------INFORMATION--------------------------"

		if [ -d $file ]								#디렉토리는 파란색
		then
			echo -e "${space}[34mfile type : `stat -c %F $file`[0m"
		elif [ -f $file ] && [[ "`ls -l $file`" = -* ]]				#일반파일은 흰색
		then
			echo "${space}file type : `stat -c %F $file`"
		else									#특수파일은 초록색
			echo -e "${space}[32mfile type : `stat -c %F $file`[0m"
		fi

		echo "${space}file size : `stat -c %s $file`"
		echo "${space}modification time : `stat -c %y $file`"
		echo "${space}permission : `stat -c %a $file`"
		echo "${space}absolute path : `realpath $file`"
		echo "${space}relative path : ./`realpath --relative-base $mypos $file`"
		echo "${space}------------------------------------------------------------"

		if [[ `pwd` = $mypos ]] && [ -d $file ] && [[ "`find $file -empty`" != "$file" ]]	#현재 실행위치이고 file이 비어있는 디렉토리가 아니라면
		then
			cd $file									#해당 디렉토리에 진입
			space='	'									#트리구조 위해 탭공백추가
			temp=$num									#새출력번호로 시작하기 위해 임시저장
			file_info									#함수 재귀적 호출
			cd ..										#다시 상위 디렉토리로 이동
			num=$temp
		fi

		num=`expr $num + 1`

	done

	space=''										#함수 나가기 전 공백 없앰
}

echo "=== print file information ==="
echo "current directory : $mypos"
echo "the number of elements : `ls | wc -l`"

file_info

