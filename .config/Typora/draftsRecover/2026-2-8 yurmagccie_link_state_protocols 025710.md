# Link State Protocols

There are two types of dynamic routing protocols:  
– Distance-vector ([BGP](https://yurmagccie.wordpress.com/tag/bgp/), EIGRP)  
– Link-state ([OSPF](https://yurmagccie.wordpress.com/tag/ospfv2/), [IS-IS](https://yurmagccie.wordpress.com/tag/is-is/))

Link-state protocols are based on Dijkstra’s algorithm. Dijkstra’s algorithm is an algorithm for finding the shortest paths between nodes in a graph. In other words, Dijkstra’s algorithm calculates a loop-free path between two vertices in a graph that could have loops.

A **graph** is made up of **vertices**, **nodes**, or **points** that are connected by **edges**, **arcs**, or **links**. One link can connect **only two** vertices.

Network vendors use the term **Shortest Path First** (SPF) calculation for running Dijkstra’s algorithm.

In order to run SFP, a router must have a **DataBase** describing the network’s topology (graph). This database is referred to as the **Link-State DataBase** (LSDB). The LSDB is formed based on **link-state information** received from neighboring routers.

Link-state information contains:  
– Router ID  
– Neighboring Routers’ ID and metric to reach them  
– Connected networks

**Update information flooding**  
Once a router (R2) receives link-state information from router (R1), R2 sends an **acknowledgment** to R1; this link-state information is **forwarded** by R2 **unmodified** out of all interfaces except the one where R2 got this information. By doing so, every router:  
– gets information about **all routers** that run this link-state protocol  
– has an **identical LSDB**

![LS-LS.1.Flooding](./images/ls-ls.1.flooding.jpg)

Every Update information packet must be acknowledged **explicitly** (OSPF) or **implicitly** (IS-IS).

A piece of Update information is called:  
– in OSPF – **Link-State Advertisement** (LSA)  
– in IS-IS – **Link-State PDU** (LSP)

**Building an adjacency**

The process of forming an adjacency consists of 2 steps:

1. **Neighbor discovery** and verification of **two-way connectivity**
2. **LSDB synchronization**

**Two-way connectivity** is is checked by receiving from the neighbor information that I send earlier. In general, it is called **Three-way handshake**, since it requires only 3 packets to verify two-way connectivity.

![3-way_handshake.draw_io](./images/3-way_handshake-draw_io1.jpg)
For a router, that have just booted up, it is essential to **synchronize** its LSDB with the neighboring routers. Once routers have discovered each other, they will sync their LSDB. This process is depicted below:

![LS-LS.2.LSDB_Sync](./images/ls-ls.2.lsdb_sync.jpg)

LSDB summary contains only headings for LSDB entries. It is called:  
– in OSFP – **DataBase Description** (DBD)  
– in IS-IS – **Complete Sequence Number PDU** (CSNP)

**LS topology**  
There are two types of physical interfaces used in enterprise networks:  
– point-to-point (p2p)  
– multi-access (Broadcast)

LS protocols are stateful – a router keeps track of the state of each router with which it is adjacent. On multi-access network routers would have formed adjacency with every other router – **full-mesh**:

![LS-LS.3.Full-mesh](./images/ls-ls.3.full-mesh.jpg)

Full-mesh topologies suffer from protocol control-plane **overhead during flooding** process. In order to overcome this issue on multi-access links, pseudonodes were introduced. **A pseudonode is a representation of the multi-access media**. Every router builds the adjacency with Pseudonode.

![LS-LS.4.Pseudonode](./images/ls-ls.4.pseudonode.jpg)

This approach simplifies the topology and decreases flooding traffic drastically, because all control-plane traffic goes to Pseudonode and Pseudonode replicates it to the rest of the routers.

Pseudonode is called:  
– in OSPF – **Designated Router** (DR)  
– in IS-IS – **Designated Intermediate System** (DIS)
