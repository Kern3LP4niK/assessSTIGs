#!/bin/bash
function createOutputFile()
{
	mkdir -p "$checkOutput/raw/"
	touch "$checkOutput/raw/V-$vulID.out"
	touch "$checkOutput/raw/V-$vulID.status"
}
function compileChecklist()
{
#	VULNNUM='237635'
	commentFile="$checkOutput/raw/V-$vulID.out"
	statusFile="$checkOutput/raw/V-$vulID.status"
	sed -i '1s;^;<COMMENTS>\n;' $commentFile	#Prepend <COMMENTS>
	printf "\n</COMMENTS>\n" >> $commentFile	#Append </COMMENTS>
#
	sed -i '1s;^;<STATUS>;' $statusFile	#Prepend <COMMENTS>
	printf "</STATUS>" >> $statusFile	#Append </COMMENTS>
	#Read from file
	sed -i -e "/V-$vulID/,/<\/VULN>/{
			/<COMMENTS>.*<\/COMMENTS>/{r $commentFile
			d}
		}" $targetChecklist
	#read Status
	sed -i -e "/V-$vulID/,/<\/VULN>/{
			/<STATUS>.*<\/STATUS>/{r $statusFile
			d}
		}" $targetChecklist

	#Clean up XML Chars
	sed -i -e "/V-$vulID/,/<\/VULN>/{
	/<COMMENTS>/,/<\/COMMENTS>/{ 
		/<COMMENTS>/b ; /<\/COMMENTS>/b ; s/\&/\&amp;/g ; s/</\&lt;/g ; s/>/\&gt;/g ; s/'/\&apos;/g ; s/\"/\&quot;/g 
		}}" $targetChecklist
} 
export thisScript="$0"
export scriptRootDir="$(dirname $(readlink -f $thisScript))"

export STIG_Folder="$1"
export checkOutput="${assessSTIGsOutputDirectory:-/tmp/scanResults/assessSTIGs/$STIG_Folder}"
mkdir -p "$checkOutput"

export targetChecklist="$2"
cp "$targetChecklist" "$checkOutput/$HOSTNAME.$STIG_Folder.ckl"
export targetChecklist="$checkOutput/$HOSTNAME.$STIG_Folder.ckl"

#source $scriptRootDir/functions.function
#source $scriptRootDir/archiveFileSystem.bash
#source $scriptRootDir/$STIG_Folder/V-*.check
#echo "$checkOutput"
source $scriptRootDir/STIGs/$STIG_Folder/copyImportantFiles.bash &
for check in $( ls -1 $scriptRootDir/STIGs/$STIG_Folder/V-*.check | sort )
do
	echo $check
	source $check 
done
