>&2 echo "Batch filling..."
mkdir -p logs
ssh ms0903 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 0 370370 > logs/fill.ms0903.log 2> logs/fill.ms0903.stderr" &
ssh ms0918 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 370370 370370 > logs/fill.ms0918.log 2> logs/fill.ms0918.stderr" &
ssh ms0907 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 740740 370370 > logs/fill.ms0907.log 2> logs/fill.ms0907.stderr" &
ssh ms0927 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 1111110 370370 > logs/fill.ms0927.log 2> logs/fill.ms0927.stderr" &
ssh ms0912 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 1481480 370370 > logs/fill.ms0912.log 2> logs/fill.ms0912.stderr" &
ssh ms0936 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 1851850 370370 > logs/fill.ms0936.log 2> logs/fill.ms0936.stderr" &
ssh ms0909 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 2222220 370370 > logs/fill.ms0909.log 2> logs/fill.ms0909.stderr" &
ssh ms0930 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 2592590 370370 > logs/fill.ms0930.log 2> logs/fill.ms0930.stderr" &
ssh ms0917 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 2962960 370370 > logs/fill.ms0917.log 2> logs/fill.ms0917.stderr" &
ssh ms0938 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 3333330 370370 > logs/fill.ms0938.log 2> logs/fill.ms0938.stderr" &
ssh ms0902 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 3703700 370370 > logs/fill.ms0902.log 2> logs/fill.ms0902.stderr" &
ssh ms0945 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 4074070 370370 > logs/fill.ms0945.log 2> logs/fill.ms0945.stderr" &
ssh ms0929 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 4444440 370370 > logs/fill.ms0929.log 2> logs/fill.ms0929.stderr" &
ssh ms0901 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 4814810 370370 > logs/fill.ms0901.log 2> logs/fill.ms0901.stderr" &
ssh ms0906 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 5185180 370370 > logs/fill.ms0906.log 2> logs/fill.ms0906.stderr" &
ssh ms0934 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 5555550 370370 > logs/fill.ms0934.log 2> logs/fill.ms0934.stderr" &
ssh ms0937 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 5925920 370370 > logs/fill.ms0937.log 2> logs/fill.ms0937.stderr" &
ssh ms1003 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 6296290 370370 > logs/fill.ms1003.log 2> logs/fill.ms1003.stderr" &
ssh ms1035 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 6666660 370370 > logs/fill.ms1035.log 2> logs/fill.ms1035.stderr" &
ssh ms1023 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 7037030 370370 > logs/fill.ms1023.log 2> logs/fill.ms1023.stderr" &
ssh ms1040 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 7407400 370370 > logs/fill.ms1040.log 2> logs/fill.ms1040.stderr" &
ssh ms1006 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 7777770 370370 > logs/fill.ms1006.log 2> logs/fill.ms1006.stderr" &
ssh ms1012 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 8148140 370370 > logs/fill.ms1012.log 2> logs/fill.ms1012.stderr" &
ssh ms1031 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 8518510 370370 > logs/fill.ms1031.log 2> logs/fill.ms1031.stderr" &
ssh ms1038 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 8888880 370370 > logs/fill.ms1038.log 2> logs/fill.ms1038.stderr" &
ssh ms1020 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 9259250 370370 > logs/fill.ms1020.log 2> logs/fill.ms1020.stderr" &
ssh ms1041 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.153.147,port=12246 9629620 370370 > logs/fill.ms1041.log 2> logs/fill.ms1041.stderr"
wait
