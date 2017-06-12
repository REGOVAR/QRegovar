# Qt Upload Plugin

Resumable Qt upload plugin.

See [`UploadInterface`](https://github.com/arifsetiawan/qt-upload-plugin/blob/master/uploadinterface.h) for plugin methods and signals

This plugin implement:

* [TUS Protocol 0.2.1](http://tus.io/protocols/resumable-upload.html) Client Implementation. Use [brewtus](https://github.com/vayam/brewtus) as test server
* Multipart file upload (not fully tested yet)

## How to use

#### 1. Load plugin using `QPluginLoader`
#### 2. Set plugin parameters:

```
uploader.setQueueSize(size)
uploader.setChunkSize(size)
uploader.setPatchVerb(patchVerb)
uploader.setUploadProtocol(protocol)
uploader.setUploadUrl(uploadUrl)
```

alternatively one can use

```
uploader.setDefaultParameters();
```

#### 3. Start upload using `append`

```
uploader.append(filepath);
```

## Example

[`PluginHost`](https://github.com/arifsetiawan/qt-plugin-host) project shows examples how to use upload plugin. Clone the project in the same directory as the plugin.
