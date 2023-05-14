<h1>Welcome to blizOS!</h1>
<p>This is the public source code for blizOS!</p>
<p>&nbsp;</p>
<p>Based on <a href="https://sourceforge.net/projects/ezarch/" target="_blank">eznix's ezarcher project.</a></p>
<p>&nbsp;</p>
<p>File tree:</p>
<p>pacman.conf - Pacman configuration file to build</p>
<p>etc/pacman.conf - Pacman configuration file for final system</p>
<p>packages.x86_64 - Packages from the repos from the builds pacman.conf file</p>
<p>profiledef.sh - Important information about the ISO - OS name, build modes, iso name, etc.</p>
<p>steps.sh - the script that builds it all</p>
<h2>&nbsp;</h2>
<h2>How to build:</h2>
<p>You need a system with the latest packages &amp; running Arch Linux or a distro based around it. It's highly recommended to use vanilla Arch but you can use any Arch distro you want really. You also need a x64 based CPU.</p>
<p>&nbsp;</p>
<p>Edit all of your configs to fit your needs first!</p>
<p>&nbsp;</p>
<p><em><strong>Also make sure your system's up to date!!!</strong></em></p>
<p>&nbsp;</p>
<blockquote>
<p>After confirming, go into your terminal into the build directory, then just run ./steps.sh as root. It should build it for you. If it fails it will give you the details on why it failed and what file.</p>
<p>&nbsp;</p>
<h2>Wheres my ISO?</h2>
<p>You should see 3 directories after building your ISO.</p>
<p>&nbsp;</p>
<ul>
<li>out</li>
<li>ezrelang</li>
<li>work</li>
</ul>
<p>The ISO output will be put into the out folder. If you want to cleanup the build process, just delete the other 2 folders.</p>
<p>&nbsp;</p>
<p><strong>&amp; thats it! Enjoy building blizOS!</strong></p>
</blockquote>