Built with Go version go1.1.2

To build:

    export GOPATH=[...]/git/epaxos/

    go install master
    go install server
    go install client

To run:

    bin/master &
    bin/server -port 7070 &
    bin/server -port 7071 &
    bin/server -port 7072 &
    bin/client


# Command Line Arguments

## Client (`client.go`)
- `-maddr`: Master address (default: "localhost").
- `-mport`: Master port (default: 7087).
- `-p`: `GOMAXPROCS` setting (default: 2).
- `-T`: Number of threads (simulated clients) to run (default: 10).
- `-or`: Max number of outstanding requests a thread can have at any given time (default: 1).
- `-l`: Force client to talk to a specific replica ID (default: -1, follows Master's leader).
- `-c`: Conflict percentage. `0-100` for Uniform; `-1` for Zipfian distribution (default: 0).
- `-theta`: Zipfian parameter (default: 0.99).
- `-z`: Number of unique keys in Zipfian distribution (default: 1e9).
- `-sr`: Key range start offset (default: 0).
- `-poisson`: Average microseconds between requests. `-1` disables Poisson (default: -1).
- `-writes`: Fraction of requests that should be writes, from `0.0` to `1.0` (default: 1.0).
- `-blindwrites`: If true, writes return to client immediately without waiting for execution (default: false).

## Master (`master.go`)
- `-port`: Port to listen on (default: 7087).
- `-N`: Total number of replicas to expect (default: 3).
- `-ips`: Comma-separated list of IP addresses in order (e.g., "127.0.0.1,127.0.0.2").

## Server (`server.go`)
- `-port`: Port to listen on (default: 7070). Note: RPC port is automatically set to `port + 1000`.
- `-maddr`: Master address (default: "localhost").
- `-mport`: Master port (default: 7087).
- `-addr`: IP address of this server instance (default: "localhost").
- `-e`: Use **Egalitarian Paxos (EPaxos)**. If false, uses **Classic Paxos** (default: false).
- `-p`: `GOMAXPROCS` setting (default: 2).
- `-thrifty`: Use only the minimum required messages for inter-replica communication.
- `-beacon`: Send beacons to other replicas to measure relative latency.
- `-durable`: Enable logging to a stable store (file).
- `-batch`: Enable batching of inter-server messages.
- `-inffix`: Enable a bound on execution latency for EPaxos.
- `-clocksync`: Clock sync strategy (0: None, 1: Quorum delay, 2: Process delay, 3: CA/VA/OR delay).
- `-clockepsilon`: Buffer in milliseconds for `OpenAfter` times (default: 4).
- `-cpuprofile`: File path to write CPU profile (default: disabled).