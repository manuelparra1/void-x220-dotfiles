# What is IS-IS?

## Questions:

```text
What is IS-IS? How is it used in modern network engineering in the enterprise and service provider domain? What are the alternatives? Why is it often compared to OSPF? What is the benefit of using IS-IS in modern network engineering to this day, as well as potential limitations or possibly updates?  How does IS-IS, OSPF, eBGP, and VXLAN Differ?  Finally, what is a TLV?   I'm using ARP to help me understand this because it involves layer 3 things but it is works at layer 2 right?  On top of that I'm also trying to use the OSI Model to understand this? Because IS-IS is a routing protocol, but it works at layer 2?  I feel it would help to revisit Network Engineering fundamentals to better understand this like:  What does routing mean? What does encapsulating mean? What does rewriting a header mean? What are protocol numbers?  What also helps is protocol numbers because IS-IS uses a different protocol besides TCP like BGP and then I learned OSPF does as well. The thing is that ip protocol numbers are used for headers in layer 3 packets right? so how does IS-IS do it for layer 2?  Also IPV6 is avoided with IS-IS right? But arp is totally different for IPV6? On top of that OSPF uses multicast? Isn't that IGMP? Multicast traffic uses it's own ip protocol number for IGMP right?
```

It sounds like you are diving deep into the "plumbing" of the internet! You’ve touched on some of the most nuanced parts of network engineering. IS-IS is often the "hidden giant"—it’s rarely used in small offices, but it runs the backbone of the entire internet.

Let's break these concepts down by starting with the fundamentals and moving into the protocol specifics.

---

1. Fundamentals: The "Rules of the Road"

Before looking at IS-IS, we need to clarify how data actually moves.

- **Routing:** The process of selecting a path for traffic in a network or between or across multiple networks. Think of it as a **GPS** deciding which highways to take.
- **Encapsulation:** The process of wrapping data in a particular protocol header. For example, your data (Segment) is wrapped in an IP header (Packet), which is then wrapped in an Ethernet header (Frame).
- **Rewriting a Header:** When a router moves a packet from one interface to another, it **strips the old Layer 2 header** (MAC address) and **writes a new one** for the next hop. The Layer 3 IP header stays the same (mostly), but the Layer 2 "envelope" changes at every stop.
- **Protocol Numbers:** These are identifiers in the IP header (at Layer 3) that tell the receiver what is inside. For example, Protocol 6 is TCP, Protocol 17 is UDP, and Protocol 89 is OSPF.

---

2. What is IS-IS and Why is it "Layer 2"?

**Intermediate System to Intermediate System (IS-IS)** is a link-state routing protocol.

The "Layer 2" Mystery

You are correct: IS-IS is unique because it **does not run on top of IP**.

- **OSPF** sits on top of IP (it uses IP Protocol 89).
- **BGP** sits on top of TCP (Port 179).
- **IS-IS** sits directly on the **Data Link Layer (Layer 2)**. It uses its own non-IP encapsulation (CLNS).

Because it doesn't use IP to communicate, IS-IS is incredibly robust. If your IP addressing scheme is broken or misconfigured, IS-IS can still talk to other routers because it only cares about the physical cable and MAC-level connectivity.

Why use it today?

IS-IS is the darling of **Service Providers** and massive **Data Centers** for two main reasons:

1. **Multi-Protocol Support (TLVs):** Because it doesn't use IP to transport its messages, it can easily carry information about IPv4, IPv6, and Segment Routing all at once.
2. **Scalability:** It is generally considered more stable for extremely large networks than OSPF.

---

3. IS-IS vs. OSPF vs. eBGP vs. VXLAN

| Technology | Layer    | Primary Role                                                                                                                            |
| ---------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **IS-IS**  | L2/L3    | **IGP (Internal Gateway Protocol):** Finds the fastest path _inside_ your own network.                                                  |
| **OSPF**   | L3       | **IGP:** The most common alternative to IS-IS; easier for humans to read/configure.                                                     |
| **eBGP**   | L4/App   | **EGP (External):** Used to connect different companies/ISPs together. It's the "language of the internet."                             |
| **VXLAN**  | L2-in-L3 | **Tunneling:** It wraps an Ethernet frame inside an IP packet so you can stretch a "virtual" Layer 2 network across a Layer 3 boundary. |

---

4. Addressing your specific questions

What is a TLV?

**TLV** stands for **Type, Length, Value**. It is a way of encoding data.

- **Type:** What kind of info is this? (e.g., "IPv6 Prefix")
- **Length:** How big is this info?
- **Value:** The actual data.  
  IS-IS uses TLVs to remain "future-proof." If a new technology comes out (like IPv10), we just add a new TLV type to IS-IS without having to rewrite the whole protocol.

Does IS-IS avoid IPv6?

**Actually, the opposite!** IS-IS is often preferred for IPv6 because of the TLVs mentioned above. You can run "Multi-Topology IS-IS," which allows you to manage IPv4 and IPv6 routing independently within the same protocol instance.

Multicast and IGMP

You asked if Multicast is just IGMP. Not quite:

- **IGMP:** This is how a **user/host** tells a router, "I want to watch this video stream."
- **OSPF Multicast:** OSPF uses specific multicast addresses (like `224.0.0.5`) just for routers to talk to each other. It doesn't use IGMP for this; it's hardcoded into the protocol.

ARP and the OSI Model

ARP (Address Resolution Protocol) is often called a "Layer 2.5" protocol. It bridges the gap. It takes a Layer 3 address (IP) and finds the Layer 2 address (MAC). You are right to use it as a reference—like IS-IS, ARP messages are broadcast directly onto the wire without an IP header.

---

Summary of Benefits & Limitations

- **Benefit:** **Neutrality.** IS-IS doesn't care if you are routing IPv4 or IPv6. It is also more secure against spoofing because you can't "ping" an IS-IS control plane from the internet (since it's not IP-based).
- **Limitation:** **Complexity.** IS-IS uses a different addressing scheme (NET addresses) that looks like `49.0001.1921.6800.1001.00`. It is less intuitive for engineers used to standard IP networking.

