# Access Control Lists

Access control lists (ACLs) are read and evaluated in a specific order to determine permissions. The exact mechanism depends on the system (e.g., file systems like NTFS, network ACLs in Cisco routers, or database ACLs), but here's a general overview with common examples:

### General Principle

- ACLs are typically processed **sequentially from top to bottom** (first-match or ordered evaluation).
- Entries are checked one by one against the subject (e.g., user, IP address) and action (e.g., read, write).
- The **first matching rule** that applies is enforced, and evaluation stops there. This makes rule ordering critical—more specific rules should come before general ones to avoid overrides.
- Deny rules often take implicit precedence if matched, but it varies by system.
- If no rules match, a default policy (e.g., deny all or allow all) applies.

### Example 1: File System ACLs (e.g., NTFS on Windows)

- ACLs are attached to files/folders and consist of **Access Control Entries (ACEs)**.
- Order of evaluation:
  1. **Inherited ACEs** from parent folders (processed first, unless overridden).
  2. **Explicit ACEs** on the object itself (top to bottom).
- Types of ACEs:
  - **Allow**: Grants permission if matched.
  - **Deny**: Explicitly blocks, even if an Allow exists elsewhere. Deny ACEs are evaluated before Allow in the same list, but overall, the first match wins.
- Propagation: Permissions can inherit down the directory tree.
- Tool to view: Use `icacls` command or File Explorer's Security tab.

Example ACL (simplified):

```
- Deny Full Control: Guest (first, so Guests are blocked immediately)
- Allow Read: Users
- Allow Write: Admins
```

If a Guest tries to access, it's denied at the first entry.

### Example 2: Network ACLs (e.g., Cisco IOS)

- Used on routers/interfaces to filter traffic.
- Processed **inbound** and **outbound** separately, with rules numbered (e.g., 10, 20).
- Evaluation order: **From lowest number to highest** (e.g., rule 10 first).
- Each rule specifies source/destination IP, protocol, action (permit/deny).
- **Implicit deny all** at the end—if no rule matches, traffic is dropped.
- No implicit allow; everything is denied unless permitted.

Example config:

```
access-list 101 deny ip 192.168.1.0 0.0.0.255 any  (rule 10: blocks LAN to anywhere)
access-list 101 permit ip any any  (rule 20: allows everything else)
```

Traffic from 192.168.1.0 is denied first; others are permitted.

### Example 3: POSIX/Linux ACLs (e.g., via `setfacl`)

- Extended ACLs build on standard owner/group/other permissions.
- Entries include **basic** (owner/group/other) and **extended** (specific users/groups).
- Evaluation order:
  1. **Owner** permissions.
  2. **Named user/group** entries (top to bottom).
  3. **Mask** (limits group permissions).
  4. **Other** permissions.
- Deny is not directly supported; use absence of permissions for denial.
- View with `getfacl`.

Example:

```
# file: example.txt
# owner: user1
# group: group1
user::rw-
user:alice:r--  (specific user first)
group::r--
mask::r--
other::---
```

Alice gets read access via her specific entry.

### Tips

- **Ordering matters**: Place specific, high-priority rules (e.g., denies for security) at the top.
- **Testing**: Always simulate or log to verify (e.g., `show access-lists` in Cisco).
- **Variations**: Cloud systems like AWS IAM evaluate policies differently (e.g., allow if any policy allows, deny if any denies, with explicit denies winning).

If you specify the context (e.g., OS, network device), I can provide more tailored details.
