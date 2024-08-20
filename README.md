JS7z - 7-Zip for JavaScript
===========================

This is a JavaScript port of the famous archiver *7-Zip*, which you can use in your own:

- Web pages
- *Node.js* projects

7-Zip is capable of extracting from lots of different and rare archive formats, and compressing many common ones.

When sent from an efficiently configured web server, JS7z uses approximately 550KB when compressed in GZip format, or about 450KB in Brotli.

The supplied version of 7-Zip is currently **24.08**.  It is ported with help from Emscripten.

Downloading Pre-Built Distributions
-----------------------------------

The latest pre-built versions can be downloaded here: https://github.com/GMH-Code/JS7z/releases

There are four main variants available:

- Multi-threaded: `[MT]`
- Multi-threaded with extended file system functionality: `[MT+FS]`
- Single-threaded: `[ST]`
- Single-threaded with extended file system functionality: `[ST+FS]`

The recommended version (if you are not sure which one you need yet), is `[MT+FS]`.

Usage
-----

Code examples are below.  Click [here](https://gmh-code.github.io/js7z/) for a website that shows many of the features in action.

Differences from Other Projects
-------------------------------

JS7z is written entirely using the official 7-Zip code as a base.  It is not a fork or clone of another project.

Some differences with JS7z include:

- Built from a new version of 7-Zip
- Runs almost entirely in separate worker threads
- Can use all available CPU cores for compression/decompression
- Safe; forces proper memory resets after each use
- The runtime and threads/workers automatically quit upon completion
- Asynchronous completion callbacks with exit statuses/reasons
- Improved exception handling coverage (optional; increases build size)
- Supports `PROXYFS` as well as `NODEFS` and `WORKERFS`, so you can chain operations between instances without needing to offload data
- Can work with JavaScript or on behalf of other WebAssembly projects
- Minimal build variants

Sample Web Page: Compress User-Supplied Files
---------------------------------------------

Here is the code for a sample webpage that can prompt the user for multiple files, compress them into `archive.zip`, and then return the compressed file:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JS7z Multi-File Compression Example</title>
  <script src="js7z.js"></script>
</head>
<body>
  <!-- Prompt the user for a file -->
  <input type="file" id="fileInput" onchange="compressFile();" multiple>

  <!-- Provide a reusable, automatically-clicked download link -->
  <a id="aExport" hidden></a>

  <!-- JS7z sample code -->
  <script>
    // Paste the sample JavaScript code here
  </script>
</body>
</html>
```

Between the `<script>` and `</script>` tags towards the bottom, or alternatively in an external `.js` file, place this JavaScript code:
```js
async function compressFile() {
  // Get the HTML file element
  const files = document.getElementById('fileInput').files;

  // Return if no files were selected
  if (files.length < 1)
    return;

  // Start up JS7z, but do not run anything yet
  js7z = await JS7z();

  // Create the input folder
  js7z.FS.mkdir('/in');

  // Write each file into the input folder
  for (const file of files) {
    const arrayBuffer = await file.arrayBuffer();
    js7z.FS.writeFile('/in/' + file.name, new Uint8Array(arrayBuffer));
  }

  // Define a function to be called when the compression is complete
  js7z.onExit = function(exitCode) {
    // Compression unsuccessful
    if (exitCode !== 0)
      return;

    // Compression successful
    const aExport = document.getElementById('aExport');
    const exportData = js7z.FS.readFile('/out/archive.zip', {encoding: 'binary'});
    const objURL = URL.createObjectURL(new Blob([exportData], {type: 'application/octet-stream'}));
    aExport.href = objURL;
    aExport.download = 'archive.zip';
    aExport.click();
    URL.revokeObjectURL(objURL);
  };

  // Start the compression process
  js7z.callMain(['a', '/out/archive.zip', '/in/*']);
}
```

This example can be improved in several ways:

- Integrate proper error handling at each stage.
- Perform certain actions if the exit code is not `0`.
- Only download JS7z asynchronously and/or when it is actually used, so users or crawlers (search engine bots) do not waste bandwidth or face rendering delays.

Other notes:

- This page will only work when hosted on a proper local or remote web server.
- The web server should be configured with 'Cross-Origin Isolation' (preferred), **or** the browser can be started with `SharedArrayBuffer` enabled, **or** you can add a loader to display the page with the correct headers configured (surprisingly, this is possible).
- The `callMain([])` array strings are the same as the individual 7-Zip command-line arguments.

Using JS7z in Node.js
---------------------

This example will run a one-off benchmark using all available CPU cores:

```js
const JS7z = require('./js7z');

JS7z().then(function(js7z) {
  js7z.callMain(['b']);
});
```

Save the file as `bench.js` and start it with `node bench.js`.  The benchmark will run in exactly the same way as if you ran `7z b`.  You should see very little speed loss, even though 7-Zip is running inside WebAssembly.

Completion Callbacks, Error Handling & Console Output
------------------------------------------------------

Ideally, all of these should be handled:

- 7-Zip writes textual information and errors to `stdout` and `stderr` respectively, which call `print(text)` and `printErr(text)` every time a line of text is flushed from the buffer.
- If the Emscripten runtime terminates unexpectedly, `onAbort(reason)` should be called with an explanation.
- When errors happen inside 7-Zip, usually `onExit(errorCode)` will be called with an error code other than `0`.
- If the Emscripten runtime has trouble starting up, for example if the `.wasm` file cannot be downloaded or the browser does not support certain features, there is a chance that the call to `JS7z()` may throw an error.

Here are two handling examples:

```js
js7z = await JS7z();

js7z.print = myPrintFunc;
js7z.printErr = myPrintErrFunc;
js7z.onAbort = myAbortFunc;
js7z.onExit = myExitFunc;

try {
  // Do some work with js7z
} catch(err) {
  console.error('Error:', err);
}
```

Or:

```js
JS7z({
  print: myPrintFunc,
  printErr: myPrintErrFunc,
  onAbort: myAbortFunc,
  onExit: myExitFunc
}).then(function(js7z) {
  // Do some work with js7z
}).catch(function(err) {
  console.error('Error:', err);
});
```

You can use variants of these two examples, but it is also a good idea to catch errors in the startup of `JS7z()`.  You should define the four *myFunc* functions with the correct arguments as indicated above, then add your handling code.

Using the File System
--------------------

JS7z uses Emscripten's file system behind the scenes, so read the [Emscripten File System Manual](https://emscripten.org/docs/api_reference/Filesystem-API.html) for information on how to use it.  You just need to place an instance name before the `FS`, as per other examples here.  Different instances of JS7z will have entirely different file systems, unless you share folders between them with `NODEFS` or `PROXYFS`.

You can also explore and experiment in the browser console.  This will list the file system features:

```js
js7z = await JS7z();
console.info(Object.keys(js7z.FS));
```

You can use `js7z.NODEFS`, `js7z.WORKERFS` and `js7z.PROXYFS` as the first parameter of `js7z.FS.mount()` to mount more file system types, providing you are using a build with those features enabled.

Bypassing the File System
-------------------------

Like in Unix/Linux systems, you *can* manually pipe data to and from `stdin` and `stdout`, thereby bypassing the file system and Emscripten's 2GB in-memory storage limit.  This does not work in all situations because compressing some file formats requires random access to files (e.g. to update tables of contents), so doing this is not usually recommended or necessary.

With `NODEFS` backend mounts, the storage limit should not be a problem.

Multi-Threaded vs. Single-Threaded Builds
-----------------------------------------

In most cases, you will want to use a multi-threaded version, but you can fall back to a single-threaded version if you like.

- Multi-thread mode works in nearly all modern browsers.  It is extremely fast, runs in the background, and returns immediately.
- Single-thread mode supports less common browsers, but is slower with certain tasks.  It also can require a bit more work to use.

Warning: Calling `callMain()` in single-thread mode *currently* returns after the command completes, so long processes can hang the browser unless you run them in a Worker.  You should still use `onExit(exitCode)` to detect a proper exit.  The single-threaded version may also run in the same asynchronous way one day.

You can detect multi-threaded shared memory support in the browser like this:

```js
const hasMultiThreadSupport = typeof SharedArrayBuffer === 'function';
```

Technical Info: Multi-Start Safety in Emscripten Projects
---------------------------------------------------------

Note that other projects may allow this, but it is usually *not safe* to run a command-line program multiple times after it has been ported to Emscripten!

In most cases, when you execute an application from the Command Prompt or Shell, memory is allocated, set, and freed at the start and end of the process' lifetime.

By design in Emscripten, there are no 'resets' between runs.  The runtime must be *completely* restarted to properly reset memory.  Emscripten works like this because programs normally have to 'exit' from WebAssembly at least tens of times a second, so the browser stays responsive.  When these programs 'exit', they are actually kept in memory, just yielding to the browser.  The browser retains variable contents (the *Heap*) for the next run, and then a *different* function is called repeatedly by the browser.  Memory is unlikely to be completely reinitialised, so that means is definitely not safe to call `main()` more than once unless the ported program has been specifically written to handle it.

A failure to totally restart the runtime can result in huge amounts of leaked memory, data corruption, and workers/threads left running until the user navigates off the page.

For this reason, if `main()` has been called once, a flag is set internally, stopping you from calling it again in that session.  The fact this flag can remain set between runs also provides evidence of the safety issue and why you should be wary about re-running programs in any Emscripten port!

Building (on Linux)
-------------------

This project is self-contained, besides requiring the Emscripten SDK.

1. Download and extract (or clone) [Emscripten](https://emscripten.org/docs/getting_started/downloads.html).
2. As per the Emscripten instructions, `install`, `activate` and set the environment variables for the latest version.
3. Run these commands to start the build:

```
cd <JS7z folder>/7z-Src/CPP/7zip/Bundles/Alone2
emmake make -f ../../cmpl_gcc.mak
```

Emscripten will be automatically detected and used during the build.

You can insert extra parameters between `emmake make` and the rest of the command:

- To build in single-thread mode, insert `ST_MODE=1`.
- To add support for mounting additional WebAssembly file systems (`NODEFS`, `WORKERFS` & `PROXYFS`), insert `WASM_EXTRA_FS=1`.
- For extra exception catching during 7-Zip runs, insert `WASM_EXCEPTION_CATCHING=1`.

Usage of these compilation flags will be displayed in 7-Zip's output.

Selecting extra exception catching will add `+EC` to the flags.  This feature allows you to see further details of failures, such as extraction security issues, corrupt archive data, and incorrect passwords.  Using this increases the build size, so it is switched off by default.

At the final stage of the build, `js7z.js` and `js7z.wasm` will be written into the `Alone2/b/g` folder.  If multi-threaded mode is chosen, `js7z.worker.js` *may* be added.  On recent versions of Emscripten, this file is an unused compatibility stub and can be deleted.

---

This documentation Copyright (C) 2024 Gregory Maynard-Hoare.  See the `7z-Src/DOC` folder for licence information.
