#!/bin/bash

rm -rf logs
mkdir -p logs

echo "Starting Master..."
./bin/master -port 7087 -N 3 -ips 127.0.0.1,127.0.0.1,127.0.0.1 > logs/master.log 2>&1 &

echo "Starting Servers..."
./bin/server -port 7070 -addr 127.0.0.1 -e -batch > logs/server-1.log 2>&1 &
./bin/server -port 7071 -addr 127.0.0.1 -e -batch > logs/server-2.log 2>&1 &
./bin/server -port 7072 -addr 127.0.0.1 -e -batch > logs/server-3.log 2>&1 &

# echo "Waiting for servers to initialize..."

# while ! grep -q "All connected!" logs/master.log 2>/dev/null; do
#     sleep 0.5
# done
echo "Waiting for all 3 replicas to acknowledge cluster readiness..."

# This waits until "All connected!" appears at least 3 times in the master log
while true; do
    COUNT=$(cat logs/master.log 2>/dev/null | grep -c "All connected!")
    
    if [ "$COUNT" -ge 3 ]; then
        break
    fi
    sleep 0.5
done

# Additionally, the Master waits 2 seconds before it starts the leader election loop
# and connects to the SMR servers. Adding a small buffer here helps.
sleep 2

echo "Cluster is fully stable. Starting Client..."
echo "All servers ready! Starting Client..."
echo "Monitoring throughput (lattput.txt)..."
echo "Press Ctrl+C to stop the experiment."
# Display the header and follow the output
# echo "Streaming Lattput (Ctrl+C to stop):"
# echo "Time(ns) | AvgLat(ms) | Tput(ops/s) | Count | TotalORs | CommitLat(ms)"
# tail -n +1 -f lattput.txt
./bin/client \
    -mport 7087 \
    -T 10 \
    -or 10 \
    -writes 0.5 \
    -c 99 \
    -poisson 1000

