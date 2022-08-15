# AudioAlignment
Align audio and video from MRI scanned data using reference audio and basic thresholding.

## Usage
```
run_audio_alignment("recon", "tres_trim_encoded", "OptoAcoustics")
```

Input parameters: directory, image_type, audio_type.

The following tree shows what image/audio filenames and structure should be for the settings in the above call. Since we are using the OptoAcoustics settings, we have 3 files to read per scan: MAIN\_\*\_pre.avi (subject audio), MAIN\_\*\_pre_ref.avi (reference audio), DSP\_OUT\_\*\_.avi (de-noised audio).
```bash
├── recon
│   ├── audio
│   │   ├── MAIN_2022-07-15,10;33;12_pre.avi
│   │   ├── MAIN_2022-07-15,10;33;12_pre_ref.avi
│   │   ├── DSP_OUT_2022-07-15,10;33;12.avi
│   │   ├── MAIN_2022-07-15,10;35;02_pre.avi
│   │   ├── MAIN_2022-07-15,10;35;02_pre_ref.avi
│   └── └── DSP_OUT_2022-07-15,10;35;02.avi
├── 103312_tRes10_TRTrim150.avi
└── 103502_tRes10_TRTrim150.avi
```


## Settings
There are a few settings that can be used alongside the alignment.

### Trim
For balanced-steady-state free precession image reconstruction, the first frames of acquired data are removed because the magnetization signal has not yet reached steady state. If this is encoded in the filename, then we can remove the appropriate frames from the audio files to keep alignment. In the "tres_trim_encoded" Image Type, this is encoded in filenames as follows: 103312_tRes10_TRTrim150.avi, where 103312 is timestamp, 10 is the temporal resolution per frame (in ms), and the amount of TR's trimmed in the image reconstruction is 150. With the temporal resolution and the number of frames used, we remove the same amount of time encoded in the audio files so alignment is still achieved.

### Sorting
To ensure alignment, we sort the filenames by timestamp and match them. This is encoded by simple indexing of the filename. For example, in the "tres_trim_encoded" Image Type, we sort the timestamps by the first 6 digits of the filename. For the "OptoAcoustics" audio type, we sort by the timestamp given in the filename.


## Custom Image/Audio Types
For your own setup, you may be using a different file naming scheme. By editing the get_path_by_audio_type() and get_path_by_imagetype() functions, you can create your own setup. Details are found in the function header. If you need help with this or running into bugs, please contact prakashk@usc.edu.



