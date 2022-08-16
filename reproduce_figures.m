% Figure reproducibility code for: 
% "Simple method for audio-video temporal alignment in speech production
%  real-time MRI"
% To download data, please go to the README.md file.
% Author: Prakash Kumar

% aligned videos will be located in the video_with_audio folder in each
% subfolder.
run_audio_alignment("recon_spiral", "OptoAcoustics", "USC");
run_audio_alignment("recon_cartesian", "OptoAcoustics", "tres_trim_encoded");
