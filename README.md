# AudioAlignment
Align audio and video from MRI scanned data using reference audio and basic thresholding.

Basic usage: call "run_audio_alignment.m" and pass in a reconstruction path.
Located in the reconstruction path must be a folder called "audio" which contains the optoacoustics recorded audio, and a folder called "recon" which contains .avi videos of the reconstructions.
The script automatically uses the names of the files to determine timestamps.
