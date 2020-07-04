# Bazel on ARM 

[![Continous Integration](https://github.com/koenvervloesem/bazel-on-arm/workflows/Tests/badge.svg)](https://github.com/koenvervloesem/bazel-on-arm/actions)
[![GitHub license](https://img.shields.io/github/license/koenvervloesem/bazel-on-arm.svg)](https://github.com/koenvervloesem/bazel-on-arm/blob/master/LICENSE)

[Bazel](https://bazel.build/) is an open source build tool from Google, used to build projects such as [TensorFlow](https://www.tensorflow.org/). Raspberry Pi OS (Raspbian) doesn't have a package for Bazel, and the Bazel project doesn't provide a binary for armhf.

Luckily, Bazel can be compiled from source on the Raspberry Pi with only a small patch. All the pieces were there yet, but Bazel on ARM is a script that streamlines this and builds Bazel for the Raspberry Pi's ARMv7 processor architecture with a single command: `make bazel`.

## System requirements

* Raspberry Pi (tested on Raspberry Pi 4B with 2 GB RAM)
* 16 GB microSD card
* [Raspberry Pi OS](https://www.raspberrypi.org/downloads/raspberry-pi-os/) (previously called Raspbian) Buster (10), 32-bit

If you manage to make this work on another version of Raspbian, another Linux distribution, another model of the Raspberry Pi or even another ARM computer, please let me know so I can generalize the script. 

## Usage

First make sure to have all build requirements for Bazel. These can be installed with:

```shell
sudo make requirements
```

This installs OpenJDK 11 and makes it your default JDK.

Note: this can take a while, because it installs a whopping 1 GB of JDK files.

Then, if you want to build the latest Bazel version supported by this project (which is stored in the file [VERSION](VERSION)), just run:

```shell
make bazel
```

If you want to build a specific Bazel version, run the build script with the version number as an argument:

```shell
./scripts/build_bazel.sh 3.3.1
```

The build script downloads Bazel's distribution file, patches it and builds the Bazel binary. The build itself takes roughly half an hour on a Raspberry Pi 4B with 2 GB RAM. If all goes well, at the end you should see a message like this:

```shell
Build successful! Binary is here: /home/pi/bazel-on-arm/bazel/output/bazel
```

You can install it to `/usr/local/bin` with:

```shell
sudo make install
```

Now you can use the `bazel` command to build other projects. Check its version with:

```shell
bazel version
```

This should show smoething like:

```shell
Extracting Bazel installation...
Build label: 3.3.1- (@non-git)
Build target: bazel-out/arm-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar                                                                                                      
Build time: Sat Jul 4 11:04:19 2020 (1593860659)
Build timestamp: 1593860659
Build timestamp as int: 1593860659
```

The message "Extracting Bazel installation..." is only shown the first time you run Bazel. It takes a couple of seconds to extract the files.

If you want to uninstall Bazel later, run:

```shell
sudo make uninstall
```

## Patching other Bazel versions
If you want to build another Bazel version than the ones supported by Bazel on ARM, just copy the unpacked Bazel distribution directory, make your changes, create the patch and put it in the directory [patches](patches) with the version number in the file name. Then the build script will pick this up. For instance:

```shell
wget https://github.com/bazelbuild/bazel/releases/download/3.3.1/3.3.1-dist.zip
cp -r bazel bazel-2
# Make your changes in the `bazel-2` directory
diff -ruN bazel bazel-2 > patches/bazel-3.3.1-arm.patch
./scripts/build_bazel.sh 3.3.1
```

If you have successfully built the release, please contribute your patch to this project by a pull request so others can benefit from it too.

The key to solve a build issue on ARM was [this fix](https://github.com/bazelbuild/bazel/issues/11643#issuecomment-650573425) by [@redsigma](https://github.com/redsigma). The two lines mentioned in that issue were the only two that needed to be patched for the Bazel versions I tried to build. This is not the cleanest solution, but it works. Chances are that you need exactly the same patch to build other recent versions of Bazel on ARM.

## Motivation 

I needed Bazel to build [TensorFlow Addons](https://www.tensorflow.org/addons), which I needed because I wanted to run [Rasa](https://rasa.com/) on my Raspberry Pi. This turned out to be a challenge, and building Bazel was the easiest part of it.

Because I don't trust a random person's binary files on a Google Drive, I decided to build Bazel myself. 

## References 

When I was searching for a Bazel build for Raspberry Pi, I encountered the following projects, which I didn't use for various reasons but they gave some helpful background information about building Bazel on ARM:

* [ochafik/rpi-raspbian-bazel](https://github.com/ochafik/rpi-raspbian-bazel): Seems to be unmaintained since end-2017.
* [PINTO0309/Bazel_bin](https://github.com/PINTO0309/Bazel_bin): Has an impressive list of pre-built binaries for armhf, aarch64 and x86_64 as well as build instructions, but no releases more recent than 2.0.0.

## License

This project is provided by [Koen Vervloesem](mailto:koen@vervloesem.eu) as open source software with the MIT license. See the [LICENSE](LICENSE) file for more information.
