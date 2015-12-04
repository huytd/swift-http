# Swift HTTP Server

Simple HTTP implementation for Swift using POSIX socket API. Running on **Mac OS X** and **Linux**.

## Compile

Run the following command to compile the source:

```
swift build
```

## Run

After successfully compile, run the server with:

```
.build/debug/http
```

Now, go to [http://localhost:8080](http://localhost:8080) to test, the response should be: `Hello World`

---

# Setting up Docker container for Swift

Create new `ubuntu` container, don't forget to expose port `8080` or whatever you want, to test the HTTP server

```
docker run -it -p 8080:8080 -v /path/to/your/host/working/folder:/src ubuntu
```

When you're in the new created `ubuntu` container, install some dependencies with `apt-get`:

```
apt-get update && apt-get install wget build-essential clang rsync libpython-all-dev libedit-dev libicu52
```

Now, download the latest Swift release for Linux:

```
wget https://swift.org/builds/ubuntu1404/swift-2.2-SNAPSHOT-2015-12-01-b/swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu14.04.tar.gz
```

Extract the downloaded `zip`:

```
tar xzf swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu14.04.tar.gz
```

Use `rsync` to move all the packages to your `/usr` folder:

```
rsync -a -v swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu14.04/usr/ /usr
```

You can delete the downloaded files (optional):

```
rm -rf swift-2.2-SNAPSHOT-2015-12-01-b-ubuntu14.04*
```

Now, you have Swift installed, test it with the following command:

```
swift --version
```
