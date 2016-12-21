#!/usr/bin/env bash

## -- Honest disclaimer --
## This script is just because i'm lazy to redo build.sbt everytime i'm starting a new repo.
## Feel free to use it, modify it and laugh about how stupid it is.

## -- commons --
scala_versions=("2.11.6" "2.12.0")

## -- setup project directory --
echo 'Please enter a path where your new project will be created'
read project_dir
if [[ ! -e $project_dir ]]; then
    mkdir $project_dir
elif [[ ! -d $project_dir ]]; then
    echo "$project_dir already exists but is not a directory" 1>&2
fi

## -- setup project name --
echo 'Please enter a name for your SBT project'
read name
sed -e "s/\${project_name}/$name/" resources/build.sbt.tpl > $project_dir/build.sbt

## -- setup scala version --
echo 'Please pick a Scala version from the following'
select version in "${scala_versions[@]}"
do
	case $REPLY in
		1|2)
			echo "You picked $version which is option $REPLY"
			sed -i -e "s/\${scala_version}/$version/" $project_dir/build.sbt
			rm $project_dir/build.sbt-e # Removing the backup created by sed -i
			break
			;;
		*)
			echo "Invalid area"
			;;
	esac
done

## -- Git init --
echo 'Do you want to enable git versioning for this project ?'
select with_git in "Yes" "No"
do
	case $with_git in
		'Yes')
			git init $project_dir
			break
			;;
		'No')
			break
			;;
		*)
	esac
done
