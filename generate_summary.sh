#!/bin/bash
dirPath='/Users/yogeshgaonkar/EMG/Quota_testing/benchmark_automation_reports/benchmark_testing_90K_load_10_min_ramp_time_16_oct'
reportFilename="$dirPath/report.csv"

if [ -f "$reportFilename" ]; then
    echo "report file $reportFilename already exists, deleting it"
    rm -rf "$reportFilename"
fi

echo "quota,run,successCount,failCount" >> $reportFilename
for dir in $(find "$dirPath" -type d)
do
    if [ "$dir" != "$dirPath" ]
    then
        echo "checking directory: $dir"
        IFS='/ ' read -r -a temparray <<< "$dir"
        arraylen=${#temparray[@]}
        arraylen=$((arraylen-1))
        echo ${temparray[$arraylen]}
        quotaValue=${temparray[$arraylen]}
        fileCount=0
        for file in "$dir"/*
        do
            if [[ -f $file ]]
            then
                if [ ${file: -4} == ".csv" ]
                then
                    echo "reading $file"
                    successCount=$(grep -o 'true' $file | wc -l)
                    failCount=$(grep -o 'false' $file | wc -l)
                    fileCount=$((fileCount+1))
                    echo "$quotaValue,$fileCount,$successCount,$failCount" >> $reportFilename
                    sed -i "s/ //g" "$reportFilename"
                fi
            fi
        done
    fi
done
