---
title: "I’m a CLI lifer who learned to love automation | Nokia"
url: "https://www.nokia.com/blog/confessions-of-a-cli-lifer-who-learned-to-love-automation"
date: "2025-12-04"
type: "full_content"
objective: "N/A"
---

# Confessions of a CLI lifer who learned to love automation

by [Andy Lapteff](/people/andy-lapteff/)

29 Aug 2025

For a long time, I thought network automation wasn’t for me.

I clung to the command-line interface (CLI) like it was the air I breathed. I figured they might even put the following quote on my tombstone: “You can have my CLI when you pry it from my cold, dead hands.” I built my career on CLI commands and I refused to relinquish, no matter which way the industry headwinds blew.

I had failed out of computer science in college, unable to wrap my head around the endless layers of abstraction contained in programming concepts. I can still see the screen: a tangle of curly braces and semicolons staring back at me like hieroglyphics I’d never learn to read.

That early experience etched a deep neural pathway in my brain. That pathway transmitted one message:

**“Coding is for developers. And you, my friend, are not a developer.”**

So I wore that badge with pride. I was a CLI jockey. I came up in the networking industry at a time when the CLI was king. Its mastery was the basis of every vendor networking certification program I pursued. I could configure almost anything in the CLI in my sleep. Often, I was configuring production networks half asleep, in an endless parade of maintenance windows. Those cryptic CLI commands that now seem arcane were the lifeblood of my career. Of all our networking careers.

Automation? That was for AI and cloud providers with teams of software engineers, not for people like me. When Python, Git, or YAML wandered into view, I waved politely and stepped aside.

## The bias trap

This was more than just a bad college experience. I was stuck in my own cognitive biases:

* **Confirmation bias** kept me locked in a loop where every struggle with a programming exercise reinforced the ‘I can’t code’ narrative.
* **Anchoring bias** meant I was still judging my abilities based on who I was decades ago, rather than who I had become as an experienced network engineer.

These biases colored the lens through which I saw the world. As long as I believed I couldn’t learn automation tools like Python and Git, reality had a way of confirming it. I avoided automation in my jobs, steered clear of DevOps tools, and convinced myself CLI mastery was enough.

## My “uh-oh” moment

I managed a large production WAN for a fintech company, where my manual, CLI-driven network operations methods were accepted and even celebrated. Then came the merger with another fintech giant. Their engineers? Fluent in automation tooling.

One day, security handed down a mandate: Change the SNMP community string on **217 devices** .

The only method I knew:

1. Log in to a jump box.
2. SSH to a device.
3. Paste pre-check commands from Notepad.
4. Paste config change.
5. Paste post-check commands.
6. Save change.
7. Check with the network operations center.
8. Repeat… 216 more times.

Just opening the required number of change tickets would have taken me days. I knew my new teammates would automate it, and when the job landed on my desk, that old fear returned. Chest tight. Stomach in knots. _They’re going to ask me to automate this. I can’t. I won’t._

I asked for help, and a colleague wrote a Python script that handled the entire change in minutes. He was kind enough to walk me through it, but to me, it looked like an alien language. I needed time to move at a slower pace, but time wasn’t an option.

And so my belief was reaffirmed: **“Automation is for developers. And you, my friend, are not a developer.”** My plan was to ride out my CLI career until they got rid of me or I found a way out.

## The great escape

That “way out” came in the form of a job at a networking vendor. No maintenance windows. No on-call rotation. No coding required. Perfect.

I dived into the business side—customer experience projects, process improvements—and I thrived. I could see a long career there. But in hindsight, I wasn’t escaping the problem, I was just delaying it.

## The reality check

That illusion ended the day I got laid off.

Scanning job postings, I saw the same skill requirements over and over. Python. Git. Infrastructure-as-code. Ansible. Terraform.

It didn’t matter that I’d been a star in my last network engineering role. Without automation skills, I didn’t even qualify for the job I’d once held. Networking certs and job descriptions agreed: Automation wasn’t optional anymore. It was table stakes.

And nothing snaps you out of a comfortable illusion quite like unemployment. My biases weren’t keeping me safe, they were locking me out.

## Breaking the barrier

Out of sheer necessity, I set my excuses and biases aside. I spun up a lab. Learned the basics of Python and Git. And one night, I used the Netmiko library to log in to a router and run a show version.

It was only a few lines of code, but for me, it was seismic: the first time I’d used a coding language to interact with network gear and have it work.

As it turns out, it wasn’t nearly as bad as my brain had been telling me for 20 years. That moment didn’t just add a skill. It broke a decades-old mental barrier. And if I could do it, maybe other CLI lifers could, too.

## Why Nokia? Why now?

When I saw the Nokia Event-Driven Automation (EDA) platform at a Networking Field Day event, it clicked.

EDA provides the network automation safety net we’ve been missing—intent-based workflows, a synced digital twin, pre- and post-checks, atomic commits, instant rollback, streaming telemetry—without demanding that anyone become a full-time software developer.

EDA isn’t “magic happens here” automation. It’s an operations platform designed to make networks safer, faster and easier to run, even in multivendor environments. And it’s proof that automation can be approachable for engineers at any skill level. From a newb like me to a Kubernetes-fueled Infrastructure-as-code scripting supernerd.

That’s why I joined Nokia. And it’s why I launched a short-form video series: Event-Driven Automation in action.

So far, the series includes videos on:

* Spinning up a free Proxmox lab
* Prepping Linux for automation
* Deploying EDA
* Building a full data center fabric in minutes

And this is just the beginning. [Subscribe to the EDA playlist](https://www.youtube.com/playlist?list=PLgKNvl454BxdqOqs3xzCXFxmRna71C90T) to learn more about reliable data center networks and multivendor infrastructure automation with this cloud-native platform.

Because if I can break decades of bias and learn this, so can you.

I still love the CLI. It’s been my sword and shield for most of my career. But the reality is that automation has taken the throne.

The CLI king isn’t gone but there’s a new ruler in town.

_The king is dead. Long live the king._

[](/people/andy-lapteff/)

## About Andy Lapteff

Andy Lapteff is the Senior Product Marketing Manager for Data Center at Nokia, where he develops strategic content that drives awareness and engagement across the portfolio. Drawing on decades of experience in technical roles at Juniper, Fiserv, Comcast, and Verizon, Andy brings deep credibility and a practitioner’s perspective to his marketing work. Andy is an active contributor to the networking community through his podcast, The Art of Network Engineering, and his leadership in the Pennsylvania Networking User Group.
