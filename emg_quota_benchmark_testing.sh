#!/bin/bash
filename='emg_quota_benchmark_testing_inputs.txt'
n=1
quotaRunCount=4
mainDir=""
jmxTemplate=""
jmeterPath=""
hostnameone=""
hostnametwo=""
port=""
reportFilename=""
while read line; do
    if [ $n -eq 1  ]
    then
        jmxTemplate=$line
        echo "using jmx file: $jmxTemplate"
    fi
    if [ $n -eq 2  ]
    then
        jmeterPath=$line
        echo "using jmeter: $jmeterPath"
    fi
    if [ $n -eq 3 ]
    then
        echo "need to create DIR : $line"
        if [ -d "$line" ]; then
            echo "dir already exists, deleting it"
            rm -rd "$line"
        fi
        echo "creating dir"
        mainDir=$line
        mkdir "$line"
        reportFilename="$mainDir/report.csv"
        if [ -f "$reportFilename" ]; then
            echo "report file $reportFilename already exists, deleting it"
            rm -rf "$reportFilename"
        fi
        echo "quota,run,successCount,failCount" >> $reportFilename
    fi
    if [ $n -eq 4  ]
    then
        quotaRunCount=$line
        echo "Need to loop each quota run: $quotaRunCount"
    fi
    if [ $n -eq 5  ]
    then
        hostnameone=$line
        echo "adding hostnameone to jmx: $hostnameone"
    fi
    if [ $n -eq 6  ]
    then
        hostnametwo=$line
        echo "adding hostnametwo to jmx: $hostnametwo"
    fi
    if [ $n -eq 7  ]
    then
        port=$line
        echo "adding port to jmx: $port"
    fi
    if [ $n -eq 8  ]
    then
        echo "need to create sub dirs for each: $line"
        IFS=', ' read -r -a quotas <<< "$line"
        for quota in "${quotas[@]}"
        do
            IFS=': ' read -r -a quotaData <<< "$quota"
            echo "creating dir Q_${quotaData[0]}_PM"
            echo "adding x-api-key to jmx: ${quotaData[1]}"
            mkdir "$mainDir/Q_${quotaData[0]}_PM"
            for i in $(seq 1 $quotaRunCount)
            do 
                csvfilename="$mainDir/Q_${quotaData[0]}_PM/Test$i.csv"
                touch "$csvfilename"
                cp "$jmxTemplate" "$mainDir/Q_${quotaData[0]}_PM/"
                sed -i "s/add_your_x_api_key/${quotaData[1]}/g" "$mainDir/Q_${quotaData[0]}_PM/$jmxTemplate"
                sed -i "s/add_your_host_one/$hostnameone/g" "$mainDir/Q_${quotaData[0]}_PM/$jmxTemplate"
                sed -i "s/add_your_host_two/$hostnametwo/g" "$mainDir/Q_${quotaData[0]}_PM/$jmxTemplate"
                sed -i "s/add_your_port/$port/g" "$mainDir/Q_${quotaData[0]}_PM/$jmxTemplate"
                sh "$jmeterPath/"jmeter -n -t "$mainDir/Q_${quotaData[0]}_PM/$jmxTemplate"  -l "$mainDir/Q_${quotaData[0]}_PM/Test$i.csv" -Jjmeter.save.saveservice.timestamp_format=yyyy/MM/dd\ HH:mm:ss.SSS -Jjmeter.save.saveservice.assertion_results_failure_message=false
                
                successCount=$(grep -o 'true' $csvfilename | wc -l)
                failCount=$(grep -o 'false' $csvfilename | wc -l)
                echo "${quotaData[0]},$i,$successCount,$failCount" >> $reportFilename
                sed -i "s/ //g" "$reportFilename"
                sleep 60
            done
        done
    fi
n=$((n+1))
done < $filename