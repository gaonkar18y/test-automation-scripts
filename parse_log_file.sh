#!/bin/bash
logFilename='log_output.log'
parsedResponseFilename='quota_apply_responses.csv'
parsedRequestsFilename='quota_apply_requests.csv'

if [ -f "$parsedResponseFilename" ]; then
            echo "file $parsedResponseFilename already exists, deleting it"
            rm -rd "$parsedResponseFilename"
fi

echo "ALLOWED,USED,EXCEEDED,AVAILABLE,EXPIRYTIME,TIMESTAMP,DEBUGMPID" >> $parsedResponseFilename

logfiledata=$(cat $logFilename | grep -a "quotas/apply response" | cut -d ' ' -f11)
echo $logfiledata | tr " " "\n" >> $parsedResponseFilename
sed -i "s/allowed//g" "$parsedResponseFilename"
sed -i "s/used//g" "$parsedResponseFilename"
sed -i "s/exceeded//g" "$parsedResponseFilename"
sed -i "s/available//g" "$parsedResponseFilename"
sed -i "s/expiryTime//g" "$parsedResponseFilename"
sed -i "s/timestamp//g" "$parsedResponseFilename"
sed -i "s/debugMpId//g" "$parsedResponseFilename"
sed -i "s/{//g" "$parsedResponseFilename"
sed -i "s/}//g" "$parsedResponseFilename"
sed -i "s/\"//g" "$parsedResponseFilename"
sed -i "s/://g" "$parsedResponseFilename"


if [ -f "$parsedRequestsFilename" ]; then
            echo "file $parsedRequestsFilename already exists, deleting it"
            rm -rd "$parsedRequestsFilename"
fi

echo "IDENTIFIER,WEIGHT,INTERVAL,ALLOW,TIMEUNIT,QUOTATYPE,USE_DEBUGMPID" >> $parsedRequestsFilename
logfiledata=$(cat $logFilename | grep -a "Remote quota request" | cut -d ' ' -f9)
echo $logfiledata | tr " " "\n" >> $parsedRequestsFilename
sed -i "s/identifier//g" "$parsedRequestsFilename"
sed -i "s/weight//g" "$parsedRequestsFilename"
sed -i "s/interval//g" "$parsedRequestsFilename"
sed -i "s/allow//g" "$parsedRequestsFilename"
sed -i "s/timeUnit//g" "$parsedRequestsFilename"
sed -i "s/quotaType//g" "$parsedRequestsFilename"
sed -i "s/debugMpId//g" "$parsedRequestsFilename"
sed -i "s/{//g" "$parsedRequestsFilename"
sed -i "s/}//g" "$parsedRequestsFilename"
sed -i "s/\"//g" "$parsedRequestsFilename"
sed -i "s/://g" "$parsedRequestsFilename"
