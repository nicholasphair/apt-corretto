# apt-corretto
Improved apt installation for Amazon Corretto.


# Motivation
`apt-key` is now [deprecated][1] and [one-line-style][2] sources are being
phased out in favor of [DEB822-style][3] sources. The [Corretto install][4]
steps instruct us to use both of these techniques. This repo shows
how you can install Corretto the modern way.


# Usage
```bash
./corretto.sh 8
```

# Goals
I think it would be nice if installing Corretto followed the pattern
of other packages like [CMake][5] or [LLVM][6]. That is, you fetch
the helper script from the apt repo and run it.

For example:
```bash
wget https://apt.corretto.aws/corretto.sh
chmod +x corretto.sh
sudo ./corretto.sh <corretto version>
```


# Other Thoughts
It would be helpful if https://apt.corretto.aws/ had a landing page/README.




[1]: http://manpages.ubuntu.com/manpages/impish/man8/apt-key.8.html
[2]: https://manpages.debian.org/impish/apt/sources.list.5.en.html#ONE-LINE-STYLE_FORMAT
[3]: https://manpages.debian.org/impish/apt/sources.list.5.en.html#DEB822-STYLE_FORMAT
[4]: https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/generic-linux-install.html#amazon-corretto-yum-verify
[5]: https://apt.kitware.com/
[6]: https://apt.llvm.org/
