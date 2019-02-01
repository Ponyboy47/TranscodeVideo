# TranscodeVideo

A Swift wrapper around the `transcode-video` command.

## Installation (SPM)
```swift
.package(url: "https://github.com/Ponyboy47/TranscodeVideo.git", from: "0.1.0")
```

## Usage
```swift
import TranscodeVideo
import TrailBlazer

let videoFile = FilePath("/path/to/file.avi")!

let transcoder = Transcoder(for: videoFile)
// Begin transcoding asynchronously
transcoder.start()

// Check progress
let progress: Double = transcoder.progress

// Get ETA
let eta: (hours: Int, minutes: Int, seconds: Int) = transcoder.eta

// Forcefully stop transcoding
transcoder.stop()

// Gracefully stop transcoding
transcoder.interrupt()

// Pause transcoding
let succeeded = transcoder.suspend()

// Resume a paused transcoding
let succeeded = transcoder.resume()

// Block until transcoding completes
transcoder.wait()

// Also block until a transcoding completes, but includes exit code and termination reason
let finish: (exitcode: Int, reason: Process.TerminationReason) = transcoder.finish()

// Get transcoder output
let output: (stdout: ReadableStream, stderr: ReadableStream) = transcoder.output()
print(output.stdout.read())
```

## License
MIT
