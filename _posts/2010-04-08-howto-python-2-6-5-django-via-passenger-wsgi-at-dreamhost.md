---
title: 'HOWTO: Python 2.6.5 + Django (via Passenger WSGI) at DreamHost'
layout: post
comments: true
permalink: /archives/2010/04/howto-python-2-6-5-django-via-passenger-wsgi-at-dreamhost.html/
bb-custom-tags:
  - python,programação
robotsmeta:
  - index,follow
onswipe_thumb:
  - '/wp-content/plugins/onswipe/thumb/thumb.php?src=/wp-content/uploads/2010/04/django.jpg&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1751444624
categories:
---
<img src="/wp-content/uploads/2010/04/django.jpg" alt="django" title="django" width="246" height="360" class="alignleft size-full wp-image-6235" />[Dreamhost][1] is a pretty decent provider for people with lots of small websites. I didn&#8217;t expect them to have, say, Python 3 (although I&#8217;d love to), but I was surprised to find their official support is just for **2.4**!

There are [instructions for custom builds][2], but they are not much supportive (&#8220;If you are positive that you need to install Python, reconsider&#8221;), and a few [unofficial][3] ones. Here are the steps **I** used &#8211; try them at your own risk, since I can&#8217;t give any guarantees other than the fact that they worked for me (hint: create a new subdomain **with its own user** and try that there first.)

(These instructions **might** also work for Python 3.0 &#8211; just replace the version numbers accordingly. I did not test that (yet), but if you do, please let me know.)

<!--more-->

The first step is to download, build and install the desired Python version (2.6.5). To do that, enable ssh access to that domain (via [Dreamhost Panel][4]), [ssh][5] to it, then issue the commands below:

<div class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">mkdir</span> work
<span style="color: #7a0874; font-weight: bold;">cd</span> work
<span style="color: #c20cb9; font-weight: bold;">wget</span> http:<span style="color: #000000; font-weight: bold;">//</span>python.org<span style="color: #000000; font-weight: bold;">/</span>ftp<span style="color: #000000; font-weight: bold;">/</span>python<span style="color: #000000; font-weight: bold;">/</span>2.6.5<span style="color: #000000; font-weight: bold;">/</span>Python-2.6.5.tgz
<span style="color: #c20cb9; font-weight: bold;">tar</span> <span style="color: #660033;">-xzvf</span> Python-2.6.5.tgz
<span style="color: #7a0874; font-weight: bold;">cd</span> Python-2.6.5
.<span style="color: #000000; font-weight: bold;">/</span>configure <span style="color: #660033;">--prefix</span>=<span style="color: #007800;">$HOME</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #7a0874; font-weight: bold;">local</span>
<span style="color: #c20cb9; font-weight: bold;">make</span>
<span style="color: #c20cb9; font-weight: bold;">make</span> <span style="color: #c20cb9; font-weight: bold;">install</span></pre>
</div>

You can do all this because the `--prefix` ensures files will be inside your home dir (but outside the `yourdomain.com` dir, so they will be private), under `~/local/bin`, `~/local/lib`, and so on.

Now prepend the `~/local/bin` directory to your path (to force your shell to &#8220;see&#8221; this Python install before Dreamhost&#8217;s) by appending the following lines to the `.bash_profile` file located on your home directory (using `vi`, `pico` or other editor):

<div class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;"># Added for custom-built python 2.6</span>
<span style="color: #007800;">PATH</span>=<span style="color: #007800;">$HOME</span><span style="color: #000000; font-weight: bold;">/</span>local<span style="color: #000000; font-weight: bold;">/</span>bin:<span style="color: #007800;">$PATH</span>
<span style="color: #7a0874; font-weight: bold;">export</span> PATH</pre>
</div>

Logoff and logon, and *voila*! You have a decent Python:

<div class="code">
        <pre class="bash" style="font-family:monospace;">$ python
Python 2.6.5 <span style="color: #7a0874; font-weight: bold;">&#40;</span>r265:<span style="color: #000000;">79063</span>, Apr  <span style="color: #000000;">8</span> <span style="color: #000000;">2010</span>, 02:<span style="color: #000000;">30</span>:<span style="color: #000000;">51</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>
<span style="color: #7a0874; font-weight: bold;">&#91;</span>GCC 4.1.2 <span style="color: #000000;">20061115</span> <span style="color: #7a0874; font-weight: bold;">&#40;</span>prerelease<span style="color: #7a0874; font-weight: bold;">&#41;</span> <span style="color: #7a0874; font-weight: bold;">&#40;</span>Debian 4.1.1-<span style="color: #000000;">21</span><span style="color: #7a0874; font-weight: bold;">&#41;</span><span style="color: #7a0874; font-weight: bold;">&#93;</span> on linux2
Type <span style="color: #ff0000;">"help"</span>, <span style="color: #ff0000;">"copyright"</span>, <span style="color: #ff0000;">"credits"</span> or <span style="color: #ff0000;">"license"</span> <span style="color: #000000; font-weight: bold;">for</span> <span style="color: #c20cb9; font-weight: bold;">more</span> information.
<span style="color: #000000; font-weight: bold;">&gt;&gt;&gt;</span></pre>
</div>

Most add-ons will find your site-packages and related directories automatically. Some `configure` scripts for makefiles may not, but adding a `--prefix=${HOME}/.local` parameter (or something like that, check the script&#8217;s help if that happens) should solve the issue.

Django can be installed onto this Python setup by following the [standard instructions][6]. In my case:

<div class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #7a0874; font-weight: bold;">cd</span> ~<span style="color: #000000; font-weight: bold;">/</span>work
<span style="color: #c20cb9; font-weight: bold;">wget</span> http:<span style="color: #000000; font-weight: bold;">//</span>www.djangoproject.com<span style="color: #000000; font-weight: bold;">/</span>download<span style="color: #000000; font-weight: bold;">/</span>1.1.1<span style="color: #000000; font-weight: bold;">/</span>tarball<span style="color: #000000; font-weight: bold;">/</span>
<span style="color: #c20cb9; font-weight: bold;">tar</span> xvzf Django-1.1.1.tar.gz
<span style="color: #7a0874; font-weight: bold;">cd</span> Django-1.1.1
python setup.py <span style="color: #c20cb9; font-weight: bold;">install</span></pre>
</div>

I also had to add [MySQL for Python][7]:

<div class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #7a0874; font-weight: bold;">cd</span> ~<span style="color: #000000; font-weight: bold;">/</span>work
<span style="color: #c20cb9; font-weight: bold;">wget</span> http:<span style="color: #000000; font-weight: bold;">//</span>downloads.sourceforge.net<span style="color: #000000; font-weight: bold;">/</span>project<span style="color: #000000; font-weight: bold;">/</span>mysql-python<span style="color: #000000; font-weight: bold;">/</span>mysql-python-test<span style="color: #000000; font-weight: bold;">/</span>1.2.3c1<span style="color: #000000; font-weight: bold;">/</span>MySQL-python-1.2.3c1.tar.gz?<span style="color: #007800;">use_mirror</span>=ufpr
<span style="color: #c20cb9; font-weight: bold;">tar</span> <span style="color: #660033;">-xvzf</span> MySQL-python-1.2.3c1.tar.gz
<span style="color: #7a0874; font-weight: bold;">cd</span> MySQL-python-1.2.3c1
python setup.py build
python setup.py <span style="color: #c20cb9; font-weight: bold;">install</span></pre>
</div>

For most libraries, however, you will prefer `easy_install`, which is part of [setuptools][8]. However, if you type `easy_install` now, it will use the Python 2.4 version (to which you can&#8217;t add libraries anyway). Let&#8217;s fix it with:

<div class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #7a0874; font-weight: bold;">cd</span> ~<span style="color: #000000; font-weight: bold;">/</span>work
<span style="color: #c20cb9; font-weight: bold;">wget</span> http:<span style="color: #000000; font-weight: bold;">//</span>pypi.python.org<span style="color: #000000; font-weight: bold;">/</span>packages<span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">2.6</span><span style="color: #000000; font-weight: bold;">/</span>s<span style="color: #000000; font-weight: bold;">/</span>setuptools<span style="color: #000000; font-weight: bold;">/</span>setuptools-0.6c11-py2.6.egg<span style="color: #666666; font-style: italic;">#md5=bfa92100bd772d5a213eedd356d64086</span>
<span style="color: #c20cb9; font-weight: bold;">bash</span> setuptools-0.6c11-py2.6.egg</pre>
</div>

After that, `easy_install` should work &#8211; if not, try `easy_install-2.6`. One caveat is that libraries that build against native binaries must have access to them on the correct places. My issue was with [lxml][9], but I solved it with [these instructions][10] (only changing `.local` to `local`).

That should allow you to add everything you need until your app works fine &#8211; that is, if you can enter `python manage.py shell` under the Django project dir, import some stuff, run your unit tests (you have coded tests, right?), etc.

Unfortunately, Dreamhost&#8217;s web server (Apache) will still use the old Python &#8211; and you need to change that to put your app online. I guess there is [some FastCGI trickery][11] for that, but a cleaner way (in my humble opinion) is to use [Passenger][12] (aka &#8220;mod_rails&#8221;, which Dreamhost [supports][13] due to the popularity of Ruby on Rails) with [Python Web Server Gateway Interface (WSGI)][14].

[Dreamhost&#8217;s documentation os Passenger WSGI][15] has a useful bootstrap script (at least if you did not start your Django project already), but let&#8217;s assume you already have one (if not, you should really [play a little bit][16] beforehand.)

In this process, we&#8217;ll separate &#8220;static&#8221; content (in fact, all non-Python stuff, including PHP/Perl pages) from the Python/Django files. Return to your domain&#8217;s configuration on Dreamhost Panel and change the &#8220;Web Directory&#8221; from `"<home dir>/yourdomain.com"` to `"<home dir>/yourdomain.com/public"` (i.e., append a &#8220;public&#8221; sub-directory), then tick the &#8220;Passenger (Ruby/Python apps only)&#8221; checkbox.

After that, wait until the `public` directory shows up and move your existing static files (if any) to it. If you haven&#8217;t already uploaded your Django project dir, put it under `yourdomain.com`, that is, side-by-side with `public`.

You should now have a directory structure like this:
*
*   /home/yourusername/
    *   local/
        *   bin/
        *   include/
        *   lib/
        *   share/
    *   yourdomain.com/
        *   public/
        *   yourDjangoProjectDirectory/
    *   logs/
    *   work/

</em>
Create a `passenger_wsgi.py` file on the &#8220;`yourdomain.com`&#8221; directory, with the lines below (replace `/home/XXXXXX` with your real home and `YYYYYY` with your Django project directory):

<div class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">import</span> <span style="color: #dc143c;">sys</span><span style="color: #66cc66;">,</span> <span style="color: #dc143c;">os</span>
INTERP <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"/home/XXXXXX/local/bin/python"</span>
<span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #dc143c;">sys</span>.<span style="color: black;">executable</span> <span style="color: #66cc66;">!=</span> INTERP: <span style="color: #dc143c;">os</span>.<span style="color: black;">execl</span><span style="color: black;">&#40;</span>INTERP<span style="color: #66cc66;">,</span> INTERP<span style="color: #66cc66;">,</span> *<span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#41;</span>
<span style="color: #dc143c;">sys</span>.<span style="color: black;">path</span>.<span style="color: black;">append</span><span style="color: black;">&#40;</span><span style="color: #dc143c;">os</span>.<span style="color: black;">getcwd</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
<span style="color: #dc143c;">os</span>.<span style="color: black;">environ</span><span style="color: black;">&#91;</span><span style="color: #483d8b;">'DJANGO_SETTINGS_MODULE'</span><span style="color: black;">&#93;</span> <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"YYYYYY.settings"</span>
<span style="color: #ff7700;font-weight:bold;">import</span> django.<span style="color: black;">core</span>.<span style="color: black;">handlers</span>.<span style="color: black;">wsgi</span>
application <span style="color: #66cc66;">=</span> django.<span style="color: black;">core</span>.<span style="color: black;">handlers</span>.<span style="color: black;">wsgi</span>.<span style="color: black;">WSGIHandler</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span></pre>
</div>

The magic here is that this file will be detected by Passenger and will be used by it whenever an URL that is not an static file under public is called. It will first switch the environment from the default Python (which we can&#8217;t change anyway) to our custom-built one, then build a Django environment (the `application` variable) which will handle valid URLs.

The beauty of this setup is that non-Python files (static content and stuff such as PHP) located inside `public` will be served directly by Apache, and your Python stuff will reside outside &#8211; [Django&#8217;s URL dispatcher][17] will control access, avoiding nasty accidents with leftover files.

After everything is set up, you can remove the `~/work` directory, and have fun with your (cheaply) hosted Python application!

 [1]: http://www.dreamhost.com/r.cgi?457883
 [2]: http://wiki.dreamhost.com/Python#Building_a_custom_version_of_Python
 [3]: http://blog.localkinegrinds.com/2007/08/20/custom-python-installation-for-django-on-dreamhost/
 [4]: https://panel.dreamhost.com/
 [5]: http://wiki.dreamhost.com/Ssh
 [6]: http://docs.djangoproject.com/en/dev/topics/install/#installing-official-release
 [7]: http://sourceforge.net/projects/mysql-python/
 [8]: http://pypi.python.org/pypi/setuptools
 [9]: http://codespeak.net/lxml/
 [10]: http://gsnedders.com/installing-lxml-on-dreamhost
 [11]: http://wiki.dreamhost.com/Python_FastCGI
 [12]: http://www.modrails.com/
 [13]: http://wiki.dreamhost.com/Passenger
 [14]: http://www.python.org/dev/peps/pep-0333/
 [15]: http://wiki.dreamhost.com/Passenger_WSGI
 [16]: http://docs.djangoproject.com/en/dev/intro/tutorial01/
 [17]: http://docs.djangoproject.com/en/dev/topics/http/urls/
