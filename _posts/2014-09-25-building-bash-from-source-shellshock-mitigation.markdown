---
layout: post
title: "Building bash from source (Shellshock mitigation for Ubuntu 13.04 and other unsupported distros)"
comments: true
og_image: /img/2014/09/tmnt.png
categories:
---

[Shellshock][1] is a serious server security issue that was made public yesterday. The best fix is to apply security updates from your Linux distribution, as they become available.

If that is not possible for any reason (e.g., unsupported distros, like the Ubuntu 13.04 boxes we have not killed yet), you will need to compile `bash` from the source (including all the patches) - which may be confusing if you are not used to build C/C++ software "by hand".

There are some scripts that compile and install a new bash (like [shellshocker.net][2]'s `curl https://shellshocker.net/fixbash | sh`), but they assume you are ok with the latest `bash` version (4.3), and I needed to stay with 4.2. Here is how I did it:

![](/img/2014/09/tmnt.png){: .center }

<!--more-->

**BEFORE APPLYING, PLEASE READ THIS:**

- You can copy and paste, but I recommend reading and applying commands one by one.
- You need a user with `sudo` powers.
- Replace "4.2" with the actual "major.minor" version of `bash` you are running (the steps will guide you into finding that).
- In the end, this will not *install* the new bash, just build it. Read below for your installation options.

```bash
# Find which is your current bash version
bash --version

# Software versions are usulally named in "max.min.patch" format, and we just
# want to advance to the latest patch.
#
# Mine was "GNU bash, version 4.2.45(1)-release (x86_64-pc-linux-gnu)", so I
# want to get the latest patch for 4.2. Let’s first get the 4.2 source:
cd ~
mkdir bash
cd bash
wget http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz
tar -xvzf bash-4.2.tar.gz
cd bash-4.2

# You can see we have no patches applied, because the file below contains
# "#define PATCHLEVEL 0" (i.e., this is 4.2.0)
cat patchlevel.h

# Now let’s grab all the patches released for it:
cd ..
wget -r -l 1 http://ftp.gnu.org/gnu/bash/bash-4.2-patches/

# Ideally we’d check the signatures, but for now it’s good enough to just
# get rid of them and other non-patch files:
rm ftp.gnu.org/gnu/bash/bash-4.2-patches/*.sig
rm ftp.gnu.org/gnu/bash/bash-4.2-patches/index*

# Apply the patches onto the source code...
cd bash-4.2
for i in ~/bash/ftp.gnu.org/gnu/bash/bash-4.2-patches/*; do patch -p0 < $i; done

# ...and now we should be on the latest PATCHLEVEL:
cat patchlevel.h

# Great, our code is ready to build. Go for it:
# (if it fails, the messages will help you. Most common issue is lack of yacc,
#  which you solve in Ubuntu/Debian with "sudo apt-get install bison")
./configure
make

# By this point, you have a bash file inside the bash-4.2 directory. Check
# if it is the version you expected (the "./" is important)...
./bash --version

# ...and that it is not vulnerable, i.e., does not print HTML when running
# this command (again, notice the "./"; you can remove it to compare the
# existing bash with the new one):
env -i  X='() { (a)=>\' ./bash -c 'echo curl -s https://bugzilla.redhat.com/'; head echo; rm -f echo
```

Now you need to replace your vulnerable bash with the new one. There are two ways of doing it:

- Installing the new `bash` with `sudo make install`. If you only have a couple servers, I recommend that.
- Manually replacing `/bin/bash` in affected servers with the new one. Only do it if the other servers use the same architecture/Linux version.

`sudo cp /wherever/my/new/bash/is/bash /bin/bash` should work, unless the server complains the file is already in use. In that case, try this:

- Move the old bash somewhere else (`sudo mv /bin/bash ~/old_bash`).
- Copy the new bash where the old one was (`sudo cp /wherever/my/new/bash/is/bash /bin/bash`).
- Re-run `bash --version` (and the vulnerability test, if you want) to check the new bash is in place. You can also log in again and `echo $BASH_VERSION`.

You may have to `chmod +x /bin/bash` and/or `chown root:root /bin/bash` if your copy didn't preserve permissions/ownership.

[1]: http://www.troyhunt.com/2014/09/everything-you-need-to-know-about.html
[2]: http://shellshocker.net
