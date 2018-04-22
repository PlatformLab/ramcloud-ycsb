>&2 echo "Batch filling..."
mkdir -p logs
ssh ms1213 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 0 333333 > logs/fill.ms1213.log 2> logs/fill.ms1213.stderr" &
ssh ms1214 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 333333 333333 > logs/fill.ms1214.log 2> logs/fill.ms1214.stderr" &
ssh ms1215 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 666666 333333 > logs/fill.ms1215.log 2> logs/fill.ms1215.stderr" &
ssh ms1216 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 999999 333333 > logs/fill.ms1216.log 2> logs/fill.ms1216.stderr" &
ssh ms1217 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 1333332 333333 > logs/fill.ms1217.log 2> logs/fill.ms1217.stderr" &
ssh ms1218 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 1666665 333333 > logs/fill.ms1218.log 2> logs/fill.ms1218.stderr" &
ssh ms1219 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 1999998 333333 > logs/fill.ms1219.log 2> logs/fill.ms1219.stderr" &
ssh ms1220 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 2333331 333333 > logs/fill.ms1220.log 2> logs/fill.ms1220.stderr" &
ssh ms1221 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 2666664 333333 > logs/fill.ms1221.log 2> logs/fill.ms1221.stderr" &
ssh ms1222 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 2999997 333333 > logs/fill.ms1222.log 2> logs/fill.ms1222.stderr" &
ssh ms1223 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 3333330 333333 > logs/fill.ms1223.log 2> logs/fill.ms1223.stderr" &
ssh ms1224 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 3666663 333333 > logs/fill.ms1224.log 2> logs/fill.ms1224.stderr" &
ssh ms1225 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 3999996 333333 > logs/fill.ms1225.log 2> logs/fill.ms1225.stderr" &
ssh ms1226 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 4333329 333333 > logs/fill.ms1226.log 2> logs/fill.ms1226.stderr" &
ssh ms1227 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 4666662 333333 > logs/fill.ms1227.log 2> logs/fill.ms1227.stderr" &
ssh ms1228 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 4999995 333333 > logs/fill.ms1228.log 2> logs/fill.ms1228.stderr" &
ssh ms1229 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 5333328 333333 > logs/fill.ms1229.log 2> logs/fill.ms1229.stderr" &
ssh ms1230 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 5666661 333333 > logs/fill.ms1230.log 2> logs/fill.ms1230.stderr" &
ssh ms1231 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 5999994 333333 > logs/fill.ms1231.log 2> logs/fill.ms1231.stderr" &
ssh ms1232 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 6333327 333333 > logs/fill.ms1232.log 2> logs/fill.ms1232.stderr" &
ssh ms1233 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 6666660 333333 > logs/fill.ms1233.log 2> logs/fill.ms1233.stderr" &
ssh ms1234 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 6999993 333333 > logs/fill.ms1234.log 2> logs/fill.ms1234.stderr" &
ssh ms1235 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 7333326 333333 > logs/fill.ms1235.log 2> logs/fill.ms1235.stderr" &
ssh ms1236 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 7666659 333333 > logs/fill.ms1236.log 2> logs/fill.ms1236.stderr" &
ssh ms1237 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 7999992 333333 > logs/fill.ms1237.log 2> logs/fill.ms1237.stderr" &
ssh ms1238 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 8333325 333333 > logs/fill.ms1238.log 2> logs/fill.ms1238.stderr" &
ssh ms1239 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 8666658 333333 > logs/fill.ms1239.log 2> logs/fill.ms1239.stderr" &
ssh ms1240 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 8999991 333333 > logs/fill.ms1240.log 2> logs/fill.ms1240.stderr" &
ssh ms1241 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 9333324 333333 > logs/fill.ms1241.log 2> logs/fill.ms1241.stderr" &
ssh ms1242 "cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workloada 10000000 basic+udp:host=128.110.154.34,port=12246 9666657 333333 > logs/fill.ms1242.log 2> logs/fill.ms1242.stderr"
wait
