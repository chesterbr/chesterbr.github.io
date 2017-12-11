---
title: iPhone Development Rants
excerpt: |
  |
    (previously published on the MIH SWAT Blog) When we talk about Apple, mankind is pretty much divided into three camps: lovers, haters and developers. Seriously, I never thought the day would come when I&#8217;d say such a thing, but the...
layout: post
comments: true
permalink: /archives/2008/10/iphone_development_rants.html/
dsq_thread_id:
  - 1751444293
categories:
---
(previously [published][1] on the [MIH SWAT Blog][2])

When we talk about Apple, mankind is pretty much divided into three camps: lovers, haters and developers. Seriously, I never thought the day would come when I&#8217;d say such a thing, but the fact is: Apple needs the other Steve. <span id="more-25"></span>No, not [Woz][3] (he is on-and-off there, but that&#8217;s another story). I mean our our sweaty, chair-throwing, monkey-dancer friend Steve Ballmer:

<p style="text-align:center">
</p>

You can say anything you want about Microsoft &#8211; but one thing is undeniably true: they treat third-party developers as their most valuable resource. Since the first ages of 16-bit Windows consolidation, it was clear that as long as their platform was the mainstream software-running machine (and the minimum bar for hardware support in the PC world), their reign would be safe.

And that translates into treating their developers well. Yes, they have to pay some fees here and there, but they are rarely left behind. [MSDN][4] and [competent MS staff][5] reveal all you need to know to develop any sort of application for Windows; backwards compatibility is taken to extremes; and all sorts of developers (from corporate form cut-and-pasters to low-level hackers) are treated as first-class citizens.

In contrast, no matter how sexy the platforms are that Apple makes available for your software to run on, they make it painstakingly clear that users are number one. Cupertino doesn&#8217;t mind at all if a tiny minor new feature creates one or a dozen [hurdles][6] for developers every other week. This is not &#8220;right&#8221; or &#8220;wrong&#8221; (and both approaches have shown their results), but it **is** something to be aware of when you consider developing for an Apple platform.

This was not seen as much of a problem for most developers, since Apple has always been a niché market (even with Mac OS X putting the Macintosh onto the radar for people outside the Mac cult). However, January 2007 saw the announcement of the iPhone, and since then the handset has received pretty much all types of review &#8211; from the Apple fanboy praise (blind to the most obvious flaws and limitations) to the most radical states of denial that ignore the (r)evolutionary aspects of the platform.

In the end, however, the number of iPhones on the market (no one has the exact real number, but it can be extrapolated to be at least 4 million after the worldwide 3G expansion) was the only important thing for developers &#8211; those numbers turn it into a big enough market to be considered by anyone that wants to deploy sophisticated mobile software applications.

(J2ME possibly beats those numbers, but having a unified platform for development is an advantage that Jobs has pushed since the early days of the first Macintosh &#8211; even [when it was almost against common sense][7]).

Development was not allowed by Apple during the first year of the iPhone&#8217;s existence, but developers found ways to bend the rules, using [alternative ways][8] to build their apps. Distribution was, however, the main hurdle: users needed to &#8220;jailbreak&#8221; their devices to get applications via alternative channels such as [Installer.app][9] (a simple, yet fragile distributed system) and [Cydia][10] (a wrap-up of the [apt][11] distribution system, which is one of the backbones of software distribution in the Linux world).

The introduction of the App Store (Apple&#8217;s official distribution system) changed the landscape, not only by introducing a legal (and ubiquitous) alternative for developers to distribute apps, but also by giving them a nice opportunity to piggyback on iTunes as a distribution channel. This approach of not having a middle man is an enabling factor for thousands of small-scale developers: one little dirty secret of the mobile application world is that mobile operators (which own the distribution and revenue channel) rarely talk to small developers &#8211; they have to market their apps by means of &#8220;publishers&#8221;, which pretty much stifle innovation and initiative in this field.

Even if you want to distribute your application for free, there are operators and handset makers that will make it hard (if not impossible) for users to download your app or transfer it via Bluetooth from other devices. Apple&#8217;s App Store distributes free content for free (well, you have to pay $99 for the iPhone Developer Membership, but it&#8217;s a fixed, once-off cost).

It&#8217;s not all roses, however: Apple imposes all sorts of restrictions &#8211; ranging from technical ones (you can&#8217;t let an application do background processing) to operational (registration as a developer takes some time to be processed; your app can&#8217;t duplicate functions on Apple&#8217;s apps; if they don&#8217;t like it you are out; you must submit source code to their approval, and nobody knows for sure [how compatible with licenses such as GPL][12] their model is). Besides that, the code signing process can be a burden to developers not used to it (even if you decide to [ignore Apple][13] and limit yourself to jailbroken iPhones).

It is a &#8220;my way or the highway&#8221; situation &#8211; but recently the first handset with Android (Google&#8217;s operating system for mobiles) [hit the market][14]. Some consider it underpowered, but others are excited by the [tricks][15] it has on its own (while some even [question][16] its openness). It is a welcome addition not only for users/developers who won&#8217;t be interested on Apple&#8217;s offerings, but also gives iPhonophiles the hope that competition will put some pressure on the Big Cupertino Brother to force it to relinquish some of the grip it has on the market.

I have high hopes that this will happen. But even if it doesn&#8217;t, it won&#8217;t stop a legion of developers (myself included) from working working on their $0.99 app, in the hopes that will be useful for one million people &#8211; and that its success will contribute to their own retirement. That is a really hard argument to beat, and it will keep the iPhone going for a long time. But unless we start to see some retired iPhone Developers on their yachts, Apple would do themselves a favor by treating iPhone developers a little bit better &#8211; or they will jump ship at the first opportunity &#8211; be their destination may be Android or otherwise.

 [1]: http://www.mihswat.com/2008/10/06/iphone-development-rants/
 [2]: http://www.mihswat.com/
 [3]: http://www.woz.org/
 [4]: http://msdn.microsoft.com
 [5]: http://blogs.msdn.com/oldnewthing/default.aspx
 [6]: http://blog.wired.com/gadgets/2008/07/interview-brent.html
 [7]: http://folklore.org/StoryView.py?project=Macintosh&story=Diagnostic_Port.txt
 [8]: http://code.google.com/p/iphone-dev/
 [9]: http://iphone.nullriver.com/beta/
 [10]: http://www.saurik.com/id/1
 [11]: http://en.wikipedia.org/wiki/Advanced_Packaging_Tool
 [12]: http://diveintomark.org/archives/2008/03/07/iphone-gpl
 [13]: http://www.saurik.com/id/8
 [14]: http://www.alleyinsider.com/2008/9/live-google-unveils-android-gphone-g1-goog-
 [15]: http://www.youtube.com/watch?v=CO7Yxyux1_k&feature=related
 [16]: http://blog.wired.com/gadgets/2008/09/g1-android-phon.html