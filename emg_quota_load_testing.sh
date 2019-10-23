
#!/bin/bash

## declare an array variable
declare -a jmxfiles=("EmgQuotaTesting_Q_60PM_Test1.jmx" "EmgQuotaTesting_Q_60PM_Test2.jmx" )

## now loop through the above array
for i in "${jmxfiles[@]}"
do
echo "runnig jmeter for $i"
sh jmeter -n -t "$i"

sleep 120

done

